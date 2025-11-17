#!/bin/bash

# rate_item.sh
# Usage: ./rate_item.sh <item_id> <rating>
# Example: ./rate_item.sh 123 5

ITEM_ID=$1
RATING=$2

# Validate inputs
if [ -z "$ITEM_ID" ]; then
    echo "Error: Item ID is required"
    exit 1
fi

if [ -z "$RATING" ]; then
    echo "Error: Rating is required"
    exit 1
fi

# Validate rating is between 1 and 5
if [ "$RATING" -lt 1 ] || [ "$RATING" -gt 5 ]; then
    echo "Error: Rating must be between 1 and 5"
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

# Add or update rating for this user on this item
jq --arg item_id "$ITEM_ID" \
   --arg user_id "$CURRENT_USER_ID" \
   --arg rating "$RATING" \
   'map(if .id == ($item_id | tonumber) then
      .ratings = (
        if .ratings then
          (.ratings | map(if .userId == ($user_id | tonumber) then
            {userId: ($user_id | tonumber), rating: ($rating | tonumber)}
          else . end) | 
          if any(.[]; .userId == ($user_id | tonumber)) then . 
          else . + [{userId: ($user_id | tonumber), rating: ($rating | tonumber)}] end)
        else
          [{userId: ($user_id | tonumber), rating: ($rating | tonumber)}]
        end
      )
    else . end)' "$ITEMS_FILE" > "${ITEMS_FILE}.tmp" && mv "${ITEMS_FILE}.tmp" "$ITEMS_FILE"

echo "Successfully rated item with $RATING stars"