#!/bin/bash

# set_item_price.sh
# Usage: ./set_item_price.sh <item_id> <new_price>
# Example: ./set_item_price.sh 123 49.99

ITEM_ID=$1
NEW_PRICE=$2

# Validate inputs
if [ -z "$ITEM_ID" ]; then
    echo "Error: Item ID is required"
    exit 1
fi

if [ -z "$NEW_PRICE" ]; then
    echo "Error: New price is required"
    exit 1
fi

# Validate price format (digits and optional single dot)
if [[ ! "$NEW_PRICE" =~ ^[0-9]+(\.[0-9]*)?$ ]]; then
    echo "Error: Price must contain only digits and at most one '.' (e.g., 5, 5.5, or 5.55)"
    exit 1
fi

# Format price to $#.##
# Round to 2 decimal places and always show 2 digits after the dot
FORMATTED_PRICE="$(printf '$%.2f' "$NEW_PRICE")"

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

# Update the price
jq --arg item_id "$ITEM_ID" \
   --arg new_price "$FORMATTED_PRICE" \
   'map(if .id == ($item_id | tonumber) then
      .price = $new_price
    else . end)' "$ITEMS_FILE" > "${ITEMS_FILE}.tmp" && mv "${ITEMS_FILE}.tmp" "$ITEMS_FILE"

echo "Successfully updated price to $FORMATTED_PRICE"
