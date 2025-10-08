#!/bin/bash

# Get store name from parameter
STORE_NAME="$1"

if [ -z "$STORE_NAME" ]; then
    echo "Error: Store name is required"
    exit 1
fi

# Path to locations.json
LOCATIONS_FILE="./json/locations.json"

if [ ! -f "$LOCATIONS_FILE" ]; then
    echo "Error: locations.json not found"
    exit 1
fi

# Check if a store with the same name already exists
EXISTING_STORE=$(jq --arg name "$STORE_NAME" '[.[] | select(.name == $name)] | length' "$LOCATIONS_FILE")

if [ "$EXISTING_STORE" -gt 0 ]; then
    echo "Error: A store with the name '$STORE_NAME' already exists"
    exit 1
fi

# Generate a random ID (0 or greater)
# Get all existing IDs and find the maximum to avoid conflicts
MAX_ID=$(jq '[.[].id] | max // -1' "$LOCATIONS_FILE")
STORE_ID=$((MAX_ID + 1))

# Alternative: truly random ID (uncomment if preferred)
# STORE_ID=$RANDOM

# Add new location to locations.json
jq --arg id "$STORE_ID" \
   --arg name "$STORE_NAME" \
   '. += [{
       "id": ($id | tonumber),
       "name": $name,
       "storeItems": []
   }]' "$LOCATIONS_FILE" > "${LOCATIONS_FILE}.tmp"

# Replace original file with updated one
mv "${LOCATIONS_FILE}.tmp" "$LOCATIONS_FILE"

echo "Successfully created store '$STORE_NAME' with ID $STORE_ID"