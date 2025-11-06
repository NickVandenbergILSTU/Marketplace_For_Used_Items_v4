#!/bin/bash

# bookmark_item.sh
# Usage: ./bookmark_item.sh <item_id>
# Toggles bookmark status (adds if not bookmarked, removes if bookmarked)

ITEM_ID=$1

# Validate inputs
if [ -z "$ITEM_ID" ]; then
    echo "Error: Item ID is required"
    exit 1
fi

# Get current user ID from local_data.json
CURRENT_USER_ID=$(jq -r '.currentlyLoggedInUserID' json/local/local_data.json)

if [ -z "$CURRENT_USER_ID" ]; then
    echo "Error: Could not determine current user"
    exit 1
fi

# Read accounts.json
ACCOUNTS_FILE="json/accounts.json"

if [ ! -f "$ACCOUNTS_FILE" ]; then
    echo "Error: Accounts file not found"
    exit 1
fi

# Check if item exists in items.json
ITEMS_FILE="json/items.json"
ITEM_EXISTS=$(jq --arg id "$ITEM_ID" 'any(.[]; .id == ($id | tonumber))' "$ITEMS_FILE")

if [ "$ITEM_EXISTS" != "true" ]; then
    echo "Error: Item not found"
    exit 1
fi

# Check if item is currently bookmarked
IS_BOOKMARKED=$(jq --arg user_id "$CURRENT_USER_ID" --arg item_id "$ITEM_ID" \
    '.[] | select(.id == ($user_id | tonumber)) | .bookmarkedItems | contains([($item_id | tonumber)])' \
    "$ACCOUNTS_FILE")

if [ "$IS_BOOKMARKED" = "true" ]; then
    # Remove bookmark
    jq --arg user_id "$CURRENT_USER_ID" \
       --arg item_id "$ITEM_ID" \
       'map(if .id == ($user_id | tonumber) then
          .bookmarkedItems = (.bookmarkedItems // [] | map(select(. != ($item_id | tonumber))))
        else . end)' "$ACCOUNTS_FILE" > "${ACCOUNTS_FILE}.tmp" && mv "${ACCOUNTS_FILE}.tmp" "$ACCOUNTS_FILE"
    
    echo "Successfully unbookmarked item"
else
    # Add bookmark
    jq --arg user_id "$CURRENT_USER_ID" \
       --arg item_id "$ITEM_ID" \
       'map(if .id == ($user_id | tonumber) then
          .bookmarkedItems = ((.bookmarkedItems // []) + [($item_id | tonumber)] | unique)
        else . end)' "$ACCOUNTS_FILE" > "${ACCOUNTS_FILE}.tmp" && mv "${ACCOUNTS_FILE}.tmp" "$ACCOUNTS_FILE"
    
    echo "Successfully bookmarked item"
fi