#!/bin/bash

accountFile="./json/accounts.json"
userID="$1"
newEmail="$2"

# Validate args
if [ -z "$userID" ] || [ -z "$newEmail" ]; then
  echo "Error: Must provide <userId> and <newEmail>" >&2
  exit 1
fi


# Check if email already exists
exists=$(jq --arg email "$newEmail" '[.[] | select(.email == $email)] | length' "$accountFile")
if [ "$exists" -gt 0 ]; then
  echo "Error: Email '$newEmail' is already taken." >&2
  exit 2
fi

# Update the email
tmp=$(mktemp)
jq --arg uid "$userID" --arg email "$newEmail" '
  map(if .id == ($uid | tonumber) then .email = $email else . end)
' "$accountFile" > "$tmp" && mv "$tmp" "$accountFile"

echo "Email updated successfully."
exit 0