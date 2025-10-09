#!/bin/bash

# Paths to JSON files
ITEMS_FILE="./json/items.json"
LOCAL_DATA_FILE="./json/local/local_data.json"
ACCOUNTS_FILE="./json/accounts.json"

# Check if required files exist
if [ ! -f "$ITEMS_FILE" ]; then
    echo "Error: items.json not found"
    exit 1
fi

if [ ! -f "$LOCAL_DATA_FILE" ]; then
    echo "Error: local_data.json not found"
    exit 1
fi

if [ ! -f "$ACCOUNTS_FILE" ]; then
    echo "Error: accounts.json not found"
    exit 1
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed"
    exit 1
fi

# Generate new item ID by finding max existing ID and adding 1
MAX_ID=$(jq '[.[].id] | max // -1' "$ITEMS_FILE")
NEW_ITEM_ID=$((MAX_ID + 1))

# Create new item with default values
NEW_ITEM=$(jq -n \
    --arg id "$NEW_ITEM_ID" \
    '{
        "id": ($id | tonumber),
        "name": "[NEW ITEM]",
        "price": "$0.00",
        "ratings": [],
        "itemComments": []
    }')

# Add new item to items.json
jq --argjson newItem "$NEW_ITEM" '. += [$newItem]' "$ITEMS_FILE" > "${ITEMS_FILE}.tmp"
mv "${ITEMS_FILE}.tmp" "$ITEMS_FILE"

# Get currently logged in user ID
CURRENT_USER_ID=$(jq '.currentlyLoggedInUserID' "$LOCAL_DATA_FILE")

if [ "$CURRENT_USER_ID" == "null" ] || [ "$CURRENT_USER_ID" == "-1" ]; then
    echo "Error: No user is currently logged in"
    exit 1
fi

# Add new item ID to user's myItems array
jq --arg userId "$CURRENT_USER_ID" \
   --arg itemId "$NEW_ITEM_ID" \
   'map(if .id == ($userId | tonumber) then 
        .myItems += [($itemId | tonumber)] 
    else . end)' "$ACCOUNTS_FILE" > "${ACCOUNTS_FILE}.tmp"
mv "${ACCOUNTS_FILE}.tmp" "$ACCOUNTS_FILE"

echo "Successfully created item '[NEW ITEM]' with ID $NEW_ITEM_ID and added to user $CURRENT_USER_ID's items"