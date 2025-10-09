#!/bin/bash

# Check whether this script is being called correctly
# Two methods; one that checks if the item name is unique, one that renames the item

ITEMS_FILE="items.json"

# USAGE:

# Validate a name without renaming
# validate_item_name 1 "Television"

# Rename an item
# rename_item 1 "Television"


# Function to validate if a new item name is unique
# Args: $1 = item_id, $2 = new_name, $3 = json_file (optional)
validate_item_name() {
    local item_id="$1"
    local new_name="$2"
    local json_file="${3:-$ITEMS_FILE}"
    
    # Trim whitespace
    new_name=$(echo "$new_name" | xargs)
    
    # Check if name is empty
    if [[ -z "$new_name" ]]; then
        echo "ERROR: Item name cannot be empty."
        return 1
    fi
    
    # Convert to lowercase for case-insensitive comparison
    local new_name_lower=$(echo "$new_name" | tr '[:upper:]' '[:lower:]')
    
    # Get all item names except the current item (case-insensitive)
    local duplicate=$(jq -r --arg id "$item_id" --arg name "$new_name_lower" '
        .[] | 
        select(.id != ($id | tonumber)) | 
        select((.name | ascii_downcase) == $name) | 
        .name
    ' "$json_file" | head -n1)
    
    if [[ -n "$duplicate" ]]; then
        echo "ERROR: The name \"$new_name\" is already used by another item."
        return 1
    fi
    
    echo "SUCCESS: Item name is valid."
    return 0
}

# Function to rename an item
# Args: $1 = item_id, $2 = new_name, $3 = json_file (optional)
rename_item() {
    local item_id="$1"
    local new_name="$2"
    local json_file="${3:-$ITEMS_FILE}"
    
    # Trim whitespace
    new_name=$(echo "$new_name" | xargs)
    
    # Check if item exists
    local item_exists=$(jq -r --arg id "$item_id" '.[] | select(.id == ($id | tonumber)) | .name' "$json_file")
    
    if [[ -z "$item_exists" ]]; then
        echo "ERROR: Item with ID $item_id not found."
        return 1
    fi
    
    # Validate the new name
    if ! validate_item_name "$item_id" "$new_name" "$json_file"; then
        return 1
    fi
    
    # Update the item name in the JSON file
    local temp_file=$(mktemp)
    jq --arg id "$item_id" --arg name "$new_name" '
        map(if .id == ($id | tonumber) then .name = $name else . end)
    ' "$json_file" > "$temp_file"
    
    mv "$temp_file" "$json_file"
    
    echo "SUCCESS: Successfully renamed item $item_id to \"$new_name\"."
    return 0
}
