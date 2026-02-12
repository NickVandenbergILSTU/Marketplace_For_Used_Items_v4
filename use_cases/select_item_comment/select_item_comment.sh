#!/bin/bash

# Get the item ID from the first parameter
ITEM_ID="$1"

# Path to local_data.json
LOCAL_DATA_JSON="json/local/local_data.json"

# Check if item ID is provided
if [ -z "$ITEM_ID" ]; then
    echo "Error: Item ID not provided"
    exit 1
fi

# Check if local_data.json exists
if [ ! -f "$LOCAL_DATA_JSON" ]; then
    echo "Error: local_data.json not found at $LOCAL_DATA_JSON"
    exit 1
fi

# Use jq to update the selectedItemCommentID field
jq --arg itemId "$ITEM_ID" '.selectedItemCommentID = ($itemId | tonumber)' "$LOCAL_DATA_JSON" > "${LOCAL_DATA_JSON}.tmp"

# Check if jq succeeded
if [ $? -eq 0 ]; then
    # Replace the original file with the modified one
    mv "${LOCAL_DATA_JSON}.tmp" "$LOCAL_DATA_JSON"
    echo "Selected item comment ID set to $ITEM_ID"
else
    # Remove temp file if jq failed
    rm -f "${LOCAL_DATA_JSON}.tmp"
    echo "Error: Failed to update selectedItemCommentID"
    exit 1
fi