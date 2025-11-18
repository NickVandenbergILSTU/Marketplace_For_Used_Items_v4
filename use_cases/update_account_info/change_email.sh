#!/bin/bash

accountFile="./json/accounts.json"
userID="$1"
newEmail="$2"

# Validate args
if [ -z "$userID" ] || [ -z "$newEmail" ]; then
  echo "Error: Must provide <userId> and <newEmail>"
  exit 1
fi


# Check if email already exists
exists=$(jq --arg e "$newEmail" '[.[] | select(.email == $e)] | length' "$accountFile")
if [ "$exists" -gt 0 ]; then
  echo "Error: Email '$newEmail' is already taken."
  exit 1
fi

if [[ ! "$newEmail" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
  echo "Error: Invalid email format. Please enter a valid email address."
  exit 1
fi

# Update the email
tmp=$(mktemp)
jq --arg uid "$userID" --arg email "$newEmail" '
  map(if .id == ($uid | tonumber) then .email = $email else . end)
' "$accountFile" > "$tmp" && mv "$tmp" "$accountFile"

echo "Email updated successfully."
exit 0