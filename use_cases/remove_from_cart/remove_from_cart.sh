#!/bin/bash
# remove_item_from_cart.sh
# Usage: ./use_cases/remove_item_from_cart/remove_item_from_cart.sh <userId> <itemId>

accountFile="./json/accounts.json"
userID="$1"
itemID="$2"

# Validate arguments
if [ -z "$userID" ] || [ -z "$itemID" ]; then
  echo "Error: Must provide both <userId> and <itemId>" >&2
  exit 1
fi

# checks if account for that ID exists
if [ ! -f "$accountFile" ]; then
  echo "Error: $accountFile not found" >&2
  exit 1
fi

# removes item from that users cart in cart array
jq --arg uid "$userID" --arg iid "$itemID" '
  map(
    if (.id == ($uid | tonumber)) then
      .itemsInCart = (.itemsInCart | map(select(. != ($iid | tonumber))))
    else
      .
    end
  )
' "$accountFile" > tmp.$$.json && mv tmp.$$.json "$accountFile"

echo "Item ID $itemID removed from user ID $userID's cart."
exit 0