#!/bin/bash

# delete_item.sh
# Usage: ./delete_item.sh <item_id>
# Removes item from items.json and cleans up references in accounts.json

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

# Read items.json
ITEMS_FILE="json/items.json"

if [ ! -f "$ITEMS_FILE" ]; then
    echo "Error: Items file not found"
    exit 1
fi

# Check if item exists
ITEM_EXISTS=$(jq --arg id "$ITEM_ID" 'any(.[]; .id == ($id | tonumber))' "$ITEMS_FILE")

if [ "$ITEM_EXISTS" != "true" ]; then
    echo "Error: Item not found"
    exit 1
fi

# Remove item from items.json
jq --arg item_id "$ITEM_ID" \
   'map(select(.id != ($item_id | tonumber)))' "$ITEMS_FILE" > "${ITEMS_FILE}.tmp" && mv "${ITEMS_FILE}.tmp" "$ITEMS_FILE"

# Clean up references in accounts.json
ACCOUNTS_FILE="json/accounts.json"

if [ -f "$ACCOUNTS_FILE" ]; then
    # Remove item from myItems, bookmarkedItems, reservedItems, and itemsInCart arrays
    jq --arg item_id "$ITEM_ID" \
       'map(
          .myItems = (.myItems // [] | map(select(. != ($item_id | tonumber)))) |
          .bookmarkedItems = (.bookmarkedItems // [] | map(select(. != ($item_id | tonumber)))) |
          .reservedItems = (.reservedItems // [] | map(select(. != ($item_id | tonumber)))) |
          .itemsInCart = (.itemsInCart // [] | map(select(. != ($item_id | tonumber)))) |
          .incomingSaleRequests = (.incomingSaleRequests // [] | map(select(.itemId != ($item_id | tonumber)))) |
          .outgoingSaleRequests = (.outgoingSaleRequests // [] | map(select(.itemId != ($item_id | tonumber))))
        )' "$ACCOUNTS_FILE" > "${ACCOUNTS_FILE}.tmp" && mv "${ACCOUNTS_FILE}.tmp" "$ACCOUNTS_FILE"
fi

# Delete item image if it exists
IMAGES_DIR="images/items"
if [ -f "${IMAGES_DIR}/${ITEM_ID}.png" ]; then
    rm "${IMAGES_DIR}/${ITEM_ID}.png"
fi

echo "Successfully deleted item and cleaned up all references"