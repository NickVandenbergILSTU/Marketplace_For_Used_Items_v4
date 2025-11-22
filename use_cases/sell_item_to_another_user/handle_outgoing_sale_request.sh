#!/bin/bash

# Script: cancel_sale_request.sh
# Purpose: Cancel an outgoing sale request
# Parameters: $1 = item_id, $2 = target_user_id

ITEM_ID=$1
TARGET_USER_ID=$2

# Path to JSON files
LOCAL_DATA_JSON="./json/local/local_data.json"
ACCOUNTS_JSON="./json/accounts.json"

# Validate parameters
if [ -z "$ITEM_ID" ] || [ -z "$TARGET_USER_ID" ]; then
    echo "Error: Missing required parameters. Usage: ./handle_outgoing_sale_request.sh <item_id> <target_user_id>"
    exit 1
fi

# Get currently logged in user ID
CURRENT_USER_ID=$(jq -r '.currentlyLoggedInUserID' "$LOCAL_DATA_JSON")

if [ "$CURRENT_USER_ID" == "null" ] || [ "$CURRENT_USER_ID" == "-1" ]; then
    echo "Error: No user is currently logged in."
    exit 1
fi

# Check if the sale request exists in current user's outgoing requests
SALE_REQUEST_EXISTS=$(jq --arg uid "$CURRENT_USER_ID" --arg tid "$TARGET_USER_ID" --arg iid "$ITEM_ID" \
    '.[] | select(.id == ($uid | tonumber)) | .outgoingSaleRequests | 
    any(.targetUserId == ($tid | tonumber) and .itemId == ($iid | tonumber))' \
    "$ACCOUNTS_JSON")

if [ "$SALE_REQUEST_EXISTS" != "true" ]; then
    echo "Error: Sale request not found."
    exit 1
fi

# Remove from current user's outgoing sale requests
jq --arg uid "$CURRENT_USER_ID" --arg tid "$TARGET_USER_ID" --arg iid "$ITEM_ID" \
    'map(if .id == ($uid | tonumber) then 
        .outgoingSaleRequests |= map(select(.targetUserId != ($tid | tonumber) or .itemId != ($iid | tonumber)))
    else . end)' \
    "$ACCOUNTS_JSON" > "${ACCOUNTS_JSON}.tmp" && mv "${ACCOUNTS_JSON}.tmp" "$ACCOUNTS_JSON"

# Remove from target user's incoming sale requests
jq --arg uid "$CURRENT_USER_ID" --arg tid "$TARGET_USER_ID" --arg iid "$ITEM_ID" \
    'map(if .id == ($tid | tonumber) then 
        .incomingSaleRequests |= map(select(.sourceUserId != ($uid | tonumber) or .itemId != ($iid | tonumber)))
    else . end)' \
    "$ACCOUNTS_JSON" > "${ACCOUNTS_JSON}.tmp" && mv "${ACCOUNTS_JSON}.tmp" "$ACCOUNTS_JSON"

# Get item name and target username for success message
ITEM_NAME=$(jq -r --arg iid "$ITEM_ID" \
    '.[] | select(.id == ($iid | tonumber)) | .name' \
    "./json/items.json")

TARGET_USERNAME=$(jq -r --arg tid "$TARGET_USER_ID" \
    '.[] | select(.id == ($tid | tonumber)) | .username' \
    "$ACCOUNTS_JSON")

echo "Success: Sale request for item '${ITEM_NAME}' to user '${TARGET_USERNAME}' has been cancelled."
exit 0