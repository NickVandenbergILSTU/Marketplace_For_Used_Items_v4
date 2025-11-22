#!/bin/bash

# Script: sell_item_to_user.sh
# Purpose: Sell an item to another user by creating sale requests
# Parameters: $1 = item_id, $2 = target_user_id

ITEM_ID=$1
TARGET_USER_ID=$2

# Path to JSON files
LOCAL_DATA_JSON="./json/local/local_data.json"
ACCOUNTS_JSON="./json/accounts.json"

# Validate parameters
if [ -z "$ITEM_ID" ] || [ -z "$TARGET_USER_ID" ]; then
    echo "Error: Missing required parameters. Usage: sell_item_to_user.sh <item_id> <target_user_id>"
    exit 1
fi

# Get currently logged in user ID
CURRENT_USER_ID=$(jq -r '.currentlyLoggedInUserID' "$LOCAL_DATA_JSON")

if [ "$CURRENT_USER_ID" == "null" ] || [ "$CURRENT_USER_ID" == "-1" ]; then
    echo "Error: No user is currently logged in."
    exit 1
fi

# Check if target user is the same as current user
if [ "$CURRENT_USER_ID" == "$TARGET_USER_ID" ]; then
    echo "Error: You cannot sell an item to yourself."
    exit 1
fi

# Check if current user owns the item
OWNS_ITEM=$(jq --arg uid "$CURRENT_USER_ID" --arg iid "$ITEM_ID" \
    '.[] | select(.id == ($uid | tonumber)) | .myItems | contains([($iid | tonumber)])' \
    "$ACCOUNTS_JSON")

if [ "$OWNS_ITEM" != "true" ]; then
    echo "Error: You do not own this item."
    exit 1
fi

# Check if target user exists
TARGET_USER_EXISTS=$(jq --arg uid "$TARGET_USER_ID" \
    'map(select(.id == ($uid | tonumber))) | length > 0' \
    "$ACCOUNTS_JSON")

if [ "$TARGET_USER_EXISTS" != "true" ]; then
    echo "Error: Target user does not exist."
    exit 1
fi

# Check if sale request already exists for this item to this user
EXISTING_REQUEST=$(jq --arg uid "$CURRENT_USER_ID" --arg tid "$TARGET_USER_ID" --arg iid "$ITEM_ID" \
    '.[] | select(.id == ($uid | tonumber)) | .outgoingSaleRequests | 
    any(.targetUserId == ($tid | tonumber) and .itemId == ($iid | tonumber))' \
    "$ACCOUNTS_JSON")

if [ "$EXISTING_REQUEST" == "true" ]; then
    echo "Error: You already have a pending sale request for this item to this user."
    exit 1
fi

# Add to current user's outgoing sale requests
jq --arg uid "$CURRENT_USER_ID" --arg tid "$TARGET_USER_ID" --arg iid "$ITEM_ID" \
    'map(if .id == ($uid | tonumber) then 
        .outgoingSaleRequests += [{
            "targetUserId": ($tid | tonumber),
            "itemId": ($iid | tonumber)
        }]
    else . end)' \
    "$ACCOUNTS_JSON" > "${ACCOUNTS_JSON}.tmp" && mv "${ACCOUNTS_JSON}.tmp" "$ACCOUNTS_JSON"

# Add to target user's incoming sale requests
jq --arg uid "$CURRENT_USER_ID" --arg tid "$TARGET_USER_ID" --arg iid "$ITEM_ID" \
    'map(if .id == ($tid | tonumber) then 
        .incomingSaleRequests += [{
            "sourceUserId": ($uid | tonumber),
            "itemId": ($iid | tonumber)
        }]
    else . end)' \
    "$ACCOUNTS_JSON" > "${ACCOUNTS_JSON}.tmp" && mv "${ACCOUNTS_JSON}.tmp" "$ACCOUNTS_JSON"

# Get item name for success message
ITEM_NAME=$(jq -r --arg iid "$ITEM_ID" \
    '.[] | select(.id == ($iid | tonumber)) | .name' \
    "./json/items.json")

TARGET_USERNAME=$(jq -r --arg tid "$TARGET_USER_ID" \
    '.[] | select(.id == ($tid | tonumber)) | .username' \
    "$ACCOUNTS_JSON")

echo "Success: Sale request sent for item '${ITEM_NAME}' to user '${TARGET_USERNAME}'."
exit 0