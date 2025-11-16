#!/bin/bash

accountFile="./json/accounts.json"
userID="14"
amount="30.00"

# Validate args
if [ -z "$userID" ] || [ -z "$amount" ]; then
  echo "Error: Must provide <userId> and <amount>" >&2
  exit 1
fi

# Validate number
if ! [[ "$amount" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
  echo "Error: Amount must be a number." >&2
  exit 2
fi

# jq: find the user, convert balance to number, add amount
tmp=$(mktemp)
jq --arg uid "$userID" --arg amount "$amount" '
  map(
    if .id == ($uid | tonumber) then
      .accountBalance = (
        ((.accountBalance // 0) | tonumber) + ($amount | tonumber)
      )
    else
      .
    end
  )
' "$accountFile" > "$tmp" && mv "$tmp" "$accountFile"

echo "Funds added successfully."
exit 0