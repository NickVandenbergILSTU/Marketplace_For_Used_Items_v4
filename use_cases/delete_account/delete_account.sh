#!/bin/bash

# File paths
LOCAL_DATA_PATH="json/local/local_data.json"
ACCOUNTS_PATH="json/accounts.json"
ITEMS_PATH="json/items.json"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Install with: sudo apt-get install jq"
    exit 1
fi

# Check if files exist
if [[ ! -f "$LOCAL_DATA_PATH" ]]; then
    echo "Error: $LOCAL_DATA_PATH not found"
    exit 1
fi

if [[ ! -f "$ACCOUNTS_PATH" ]]; then
    echo "Error: $ACCOUNTS_PATH not found"
    exit 1
fi

if [[ ! -f "$ITEMS_PATH" ]]; then
    echo "Error: $ITEMS_PATH not found"
    exit 1
fi

# Get the user ID to delete
USER_ID=$(jq -r '.currentlyLoggedInUserID' "$LOCAL_DATA_PATH")
echo "Deleting account with ID: $USER_ID"

# Delete the account object from accounts.json
jq "map(select(.id != $USER_ID))" "$ACCOUNTS_PATH" > "$ACCOUNTS_PATH.tmp" && mv "$ACCOUNTS_PATH.tmp" "$ACCOUNTS_PATH"

# Remove user ID from ratings arrays and item comments in items.json
jq "
  map(
    .ratings |= map(select(.accountId != $USER_ID)) |
    if .itemComments then .itemComments |= map(select(.commenterId != $USER_ID)) else . end
  )
" "$ITEMS_PATH" > "$ITEMS_PATH.tmp" && mv "$ITEMS_PATH.tmp" "$ITEMS_PATH"

echo "Account deletion complete!"