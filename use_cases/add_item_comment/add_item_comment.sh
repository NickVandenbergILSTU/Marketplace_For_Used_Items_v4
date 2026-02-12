#!/bin/bash

# Get parameters
ITEM_ID="$1"
COMMENT_TEXT="$2"

# Paths
ITEMS_JSON="json/items.json"
LOCAL_DATA_JSON="json/local/local_data.json"

# Check if parameters are provided
if [ -z "$ITEM_ID" ]; then
    echo "Error: Item ID not provided"
    exit 1
fi

if [ -z "$COMMENT_TEXT" ]; then
    echo "Error: Comment text not provided"
    exit 1
fi

# Check if files exist
if [ ! -f "$ITEMS_JSON" ]; then
    echo "Error: items.json not found at $ITEMS_JSON"
    exit 1
fi

if [ ! -f "$LOCAL_DATA_JSON" ]; then
    echo "Error: local_data.json not found at $LOCAL_DATA_JSON"
    exit 1
fi

# Get the currently logged in user ID
COMMENTER_ID=$(jq -r '.currentlyLoggedInUserID' "$LOCAL_DATA_JSON")

if [ -z "$COMMENTER_ID" ] || [ "$COMMENTER_ID" = "null" ]; then
    echo "Error: No user logged in"
    exit 1
fi

# Find the maximum commentId across all items
MAX_COMMENT_ID=$(jq '[.[] | .itemComments[]? | .commentId // 0] | max // 0' "$ITEMS_JSON")

# Calculate the new comment ID
NEW_COMMENT_ID=$((MAX_COMMENT_ID + 1))

# Add the new comment to the item with matching ID
jq --arg itemId "$ITEM_ID" \
   --arg commentBody "$COMMENT_TEXT" \
   --arg commenterId "$COMMENTER_ID" \
   --arg commentId "$NEW_COMMENT_ID" '
    map(
        if .id == ($itemId | tonumber) then
            .itemComments += [{
                "commentBody": $commentBody,
                "commenterId": ($commenterId | tonumber),
                "commentId": ($commentId | tonumber)
            }]
        else
            .
        end
    )
' "$ITEMS_JSON" > "${ITEMS_JSON}.tmp"

# Check if jq succeeded
if [ $? -eq 0 ]; then
    # Replace the original file with the modified one
    mv "${ITEMS_JSON}.tmp" "$ITEMS_JSON"
    echo "Comment successfully added to item $ITEM_ID with comment ID $NEW_COMMENT_ID"
else
    # Remove temp file if jq failed
    rm -f "${ITEMS_JSON}.tmp"
    echo "Error: Failed to add comment"
    exit 1
fi