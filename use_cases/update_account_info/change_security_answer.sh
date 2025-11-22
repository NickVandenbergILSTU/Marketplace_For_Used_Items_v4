#!/bin/bash

accountFile="./json/accounts.json"
userID="$1"
newSecurityAnswer="$2"

# Update the security answer
tmp=$(mktemp)
jq --arg uid "$userID" --arg sa "$newSecurityAnswer" '
  map(if .id == ($uid | tonumber) then .securityAnswer = $sa else . end)
' "$accountFile" > "$tmp" && mv "$tmp" "$accountFile"

echo "Security answer updated successfully."
exit 0