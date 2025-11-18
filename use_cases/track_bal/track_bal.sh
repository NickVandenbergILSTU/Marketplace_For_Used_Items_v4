#!/bin/bash

# ===================================================
echo "This script had errors, refactored changes into track_balance.py"
exit 1
# ===================================================

LOCAL_DATA_FILE="json/local/local_data.json"
ACCOUNTS_FILE="json/accounts.json"
ITEMS_FILE="json/items.json"

# Check if files exist
if [ ! -f "$LOCAL_DATA_FILE" ]; then
    echo "Error: $LOCAL_DATA_FILE not found"
    exit 1
fi

if [ ! -f "$ACCOUNTS_FILE" ]; then
    echo "Error: $ACCOUNTS_FILE not found"
    exit 1
fi

if [ ! -f "$ITEMS_FILE" ]; then
    echo "Error: $ITEMS_FILE not found"
    exit 1
fi

# Get the currently logged in user ID
CURRENT_USER_ID=$(jq -r '.currentlyLoggedInUserID' "$LOCAL_DATA_FILE")

if [ -z "$CURRENT_USER_ID" ] || [ "$CURRENT_USER_ID" = "null" ]; then
    echo "Error: No user currently logged in"
    exit 1
fi

# Get user's account balance and items in cart
USER_DATA=$(jq --argjson userId "$CURRENT_USER_ID" '
    .[] | select(.id == $userId) | {balance: .accountBalance, cart: .itemsInCart}
' "$ACCOUNTS_FILE")

ACCOUNT_BALANCE=$(echo "$USER_DATA" | jq -r '.balance')
CART_ITEMS=$(echo "$USER_DATA" | jq -r '.cart[]')

if [ -z "$CART_ITEMS" ]; then
    echo "Cart is empty"
    echo "Total: $0.00"
    echo "Account Balance: \$$ACCOUNT_BALANCE"
    exit 0
fi

# Calculate total price of items in cart
TOTAL=0
echo "Items in cart:"
echo ""

while IFS= read -r ITEM_ID; do
    ITEM_DATA=$(jq --argjson itemId "$ITEM_ID" '
        .[] | select(.id == $itemId) | {name: .name, price: .price}
    ' "$ITEMS_FILE")
    
    if [ -z "$ITEM_DATA" ]; then
        echo "Warning: Item ID $ITEM_ID not found in items.json"
        continue
    fi
    
    ITEM_NAME=$(echo "$ITEM_DATA" | jq -r '.name')
    ITEM_PRICE=$(echo "$ITEM_DATA" | jq -r '.price')
    
    # Remove $ and convert to numeric value
    PRICE_NUMERIC=$(echo "$ITEM_PRICE" | sed 's/\$//g')
    
    echo "  - $ITEM_NAME: $ITEM_PRICE"
    
    # Add to total using bc for floating point arithmetic
    TOTAL=$(echo "$TOTAL + $PRICE_NUMERIC" | bc)
done <<< "$CART_ITEMS"

echo ""
echo "total: $TOTAL"
echo "account balance: $ACCOUNT_BALANCE"
echo ""

# Compare total with account balance
COMPARISON=$(echo "$TOTAL > $ACCOUNT_BALANCE" | bc)

if [ "$COMPARISON" -eq 1 ]; then
    echo "Error: Cart total exceeds account balance"
    exit 1
else
    echo "Sufficient funds available"
    exit 0
fi