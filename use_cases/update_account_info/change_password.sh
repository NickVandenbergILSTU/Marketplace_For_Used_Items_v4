#!/bin/bash

accountFile="./json/accounts.json"
userID="$1"
newPassword="$2"

if [ -z "$userID" ] || [ -z "$newPassword" ]; then
  echo "Error: Must provide <userId> and <newPassword>" >&2
  exit 1
fi

./use_cases/check_password_requirements/check_password_requirements.sh "$newPassword"
if [ $? -ne 0 ]; then
    echo "Password does not meet requirements. Please try again."
    exit 1
fi

tmp=$(mktemp)
jq --arg uid "$userID" --arg pass "$newPassword" '
  map(if .id == ($uid | tonumber) then .password = $pass else . end)
' "$accountFile" > "$tmp" && mv "$tmp" "$accountFile"

echo "password updated successfully."
exit 0