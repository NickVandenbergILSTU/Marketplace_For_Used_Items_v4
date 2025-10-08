#!/bin/bash

# Script to update currentStore in local_data.json
# Usage: ./set_current_store.sh <store_id>

STORE_ID="$1"
LOCAL_DATA_PATH="./json/local/local_data.json"

# Check if store ID was provided
if [ -z "$STORE_ID" ]; then
    echo "Error: No store ID provided"
    exit 1
fi

# Check if local_data.json exists
if [ ! -f "$LOCAL_DATA_PATH" ]; then
    echo "Error: local_data.json not found at $LOCAL_DATA_PATH"
    exit 1
fi

# Update currentStore value using jq
if command -v jq &> /dev/null; then
    # Use jq if available
    jq --arg store_id "$STORE_ID" '.currentStore = ($store_id | tonumber)' "$LOCAL_DATA_PATH" > "${LOCAL_DATA_PATH}.tmp" && mv "${LOCAL_DATA_PATH}.tmp" "$LOCAL_DATA_PATH"
    echo "Successfully set currentStore to $STORE_ID"
else
    # Fallback using sed if jq is not available
    sed -i.bak "s/\"currentStore\": [0-9]*/\"currentStore\": $STORE_ID/" "$LOCAL_DATA_PATH"
    rm -f "${LOCAL_DATA_PATH}.bak"
    echo "Successfully set currentStore to $STORE_ID"
fi

exit 0