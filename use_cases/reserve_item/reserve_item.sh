#!/bin/bash

# Check if item ID is provided
if [ -z "$1" ]; then
    echo "Error: Item ID required"
    echo "Usage: $0 <item_id>"
    exit 1
fi

ITEM_ID=$1
LOCAL_DATA_FILE="json/local/local_data.json"
ACCOUNTS_FILE="json/accounts.json"

# Check if files exist
if [ ! -f "$LOCAL_DATA_FILE" ]; then
    echo "Error: $LOCAL_DATA_FILE not found"
    exit 1
fi

if [ ! -f "$ACCOUNTS_FILE" ]; then
    echo "Error: $ACCOUNTS_FILE not found"
    exit 1
fi

# Get the currently logged in user ID
CURRENT_USER_ID=$(jq -r '.currentlyLoggedInUserID' "$LOCAL_DATA_FILE")

if [ -z "$CURRENT_USER_ID" ] || [ "$CURRENT_USER_ID" = "null" ]; then
    echo "Error: No user currently logged in"
    exit 1
fi

# Check if item is reserved by another user
OTHER_USER_HAS_ITEM=$(jq --argjson userId "$CURRENT_USER_ID" --argjson itemId "$ITEM_ID" '
    .[] | select(.id != $userId) | .reservedItems[] | select(. == $itemId)
' "$ACCOUNTS_FILE")

if [ -n "$OTHER_USER_HAS_ITEM" ]; then
    echo "Error: Item $ITEM_ID is already reserved by another user"
    exit 1
fi

# Check if current user already has the item reserved
USER_HAS_ITEM=$(jq --argjson userId "$CURRENT_USER_ID" --argjson itemId "$ITEM_ID" '
    .[] | select(.id == $userId) | .reservedItems[] | select(. == $itemId)
' "$ACCOUNTS_FILE")

# Create a temporary file for the updated JSON
TEMP_FILE=$(mktemp)

if [ -n "$USER_HAS_ITEM" ]; then
    # User already has item reserved - remove it (unreserve)
    jq --argjson userId "$CURRENT_USER_ID" --argjson itemId "$ITEM_ID" '
        map(if .id == $userId then 
            .reservedItems |= map(select(. != $itemId))
        else . end)
    ' "$ACCOUNTS_FILE" > "$TEMP_FILE"
    
    mv "$TEMP_FILE" "$ACCOUNTS_FILE"
    echo "Item $ITEM_ID has been unreserved from user $CURRENT_USER_ID"
else
    # User doesn't have item reserved - add it (reserve)
    jq --argjson userId "$CURRENT_USER_ID" --argjson itemId "$ITEM_ID" '
        map(if .id == $userId then 
            .reservedItems += [$itemId]
        else . end)
    ' "$ACCOUNTS_FILE" > "$TEMP_FILE"
    
    mv "$TEMP_FILE" "$ACCOUNTS_FILE"
    echo "Item $ITEM_ID has been reserved for user $CURRENT_USER_ID"
fi

exit 0