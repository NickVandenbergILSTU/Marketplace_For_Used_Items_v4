#!/bin/bash

# Script to delete account from accounts.json
# Usage: ./delete_account.sh <account_id>
ACCOUNTS_FILE="json/accounts.json"
ITEMS_FILE="json/items.json"
LOCAL_DATA_PATH="json/local/local_data.json"

TOTAL_IN_CART=0

USER_ID=$(jq -r '.currentlyLoggedInUserID' $LOCAL_DATA_PATH)

USER_DATA=$(jq ".[] | select(.id == $USER_ID)" "$ACCOUNTS_FILE")

BALANCE=$(echo "$USER_DATA"| jq -r '.accountBalance // .accountBalance // 0')

CART_ITEMS=$(echo "$USER_DATA"| jq -r '.itemsInCart[]')

if [[ -z "$CART_ITEMS" ]]; then
  echo "No items in cart."
  exit 0
fi

while IFS= read -r ITEM_ID; do
    ITEM_DATA=$(jq ".[] | select(.id == $ITEM_ID)" $ITEMS_FILE)

    if [[ -z "$ITEM_DATA" ]]; then
      echo "Item with ID $ITEM_ID not found."
      continue
    fi

    ITEM_PRICE=$(echo "$ITEM_DATA" | jq -r '.price '| sed 's/[$,]//g'| tr -d ' ')

    TOTAL_IN_CART=$(echo "$TOTAL_IN_CART + $ITEM_PRICE" | bc)


    done <<< "$CART_ITEMS"

if (( $(echo "$BALANCE < $TOTAL_IN_CART" | bc -l) )); then
  echo "Insufficient balance. Your balance is $BALANCE, but the total cost is $TOTAL_IN_CART."
  exit 1
else
    echo "Sufficient balance. Your balance is $BALANCE, and the total cost is $TOTAL_IN_CART."
    exit 0
fi

