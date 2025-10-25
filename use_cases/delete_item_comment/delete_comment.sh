#!/bin/bash

# Get the comment ID from the first parameter
COMMENT_ID="$1"

# Path to items.json
ITEMS_JSON="json/items.json"

# Check if comment ID is provided
if [ -z "$COMMENT_ID" ]; then
    echo "Error: Comment ID not provided"
    exit 1
fi

# Check if items.json exists
if [ ! -f "$ITEMS_JSON" ]; then
    echo "Error: items.json not found at $ITEMS_JSON"
    exit 1
fi

# Use jq to remove the comment with the matching commentId from all items
jq --arg commentId "$COMMENT_ID" '
    map(
        if .itemComments then
            .itemComments |= map(select(.commentId != ($commentId | tonumber)))
        else
            .
        end
    )
' "$ITEMS_JSON" > "${ITEMS_JSON}.tmp"

# Check if jq succeeded
if [ $? -eq 0 ]; then
    # Replace the original file with the modified one
    mv "${ITEMS_JSON}.tmp" "$ITEMS_JSON"
    echo "Comment with ID $COMMENT_ID successfully deleted"
else
    # Remove temp file if jq failed
    rm -f "${ITEMS_JSON}.tmp"
    echo "Error: Failed to delete comment"
    exit 1
fi