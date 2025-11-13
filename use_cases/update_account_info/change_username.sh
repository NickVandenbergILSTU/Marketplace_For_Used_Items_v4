#!/bin/bash

accountFile="./json/accounts.json"
userID="$1"
newUsername="$2"

# Validate args
if [ -z "$userID" ] || [ -z "$newUsername" ]; then
  echo "Error: Must provide <userId> and <newUsername>" >&2
  exit 1
fi


# Check if username already exists
exists=$(jq --arg name "$newUsername" '[.[] | select(.username == $name)] | length' "$accountFile")
if [ "$exists" -gt 0 ]; then
  echo "Username '$newUsername' is already taken."
  exit 1
fi

# Update the username
tmp=$(mktemp)
jq --arg uid "$userID" --arg name "$newUsername" '
  map(if .id == ($uid | tonumber) then .username = $name else . end)
' "$accountFile" > "$tmp" && mv "$tmp" "$accountFile"

echo "Username updated successfully."
exit 0