#!/bin/bash

# $1: item ID
ITEM_ID="$1"

# $2: new name
NEW_NAME="$2"
JSON_PATH="json/items.json"

# Rename item with id ITEM_ID to NEW_NAME
jq --arg id "$ITEM_ID" --arg name "$NEW_NAME" '
  map(if .id == ($id|tonumber) then .name = $name else . end)
' "$JSON_PATH" > tmp.$$.json && mv tmp.$$.json "$JSON_PATH"