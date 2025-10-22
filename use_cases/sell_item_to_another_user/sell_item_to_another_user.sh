#!/bin/bash

# sell_item.sh - Transfer item ownership from seller to buyer
# Usage: ./sell_item.sh <seller_id> <buyer_id> <item_id>

SELLER_ID="$1"
BUYER_ID="$2"
ITEM_ID="$3"

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define paths relative to script location (use_cases/sell_item_to_another_user/)
ACCOUNTS_PATH="$SCRIPT_DIR/../../json/accounts.json"
ITEMS_PATH="$SCRIPT_DIR/../../json/items.json"

# Validate arguments
if [ -z "$SELLER_ID" ] || [ -z "$BUYER_ID" ] || [ -z "$ITEM_ID" ]; then
    echo "Error: Missing required arguments"
    echo "Usage: $0 <seller_id> <buyer_id> <item_id>"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed"
    echo "Install with: sudo apt-get install jq (Ubuntu/Debian) or brew install jq (macOS)"
    exit 1
fi

# Check if files exist
if [ ! -f "$ACCOUNTS_PATH" ]; then
    echo "Error: accounts.json not found at $ACCOUNTS_PATH"
    exit 1
fi

if [ ! -f "$ITEMS_PATH" ]; then
    echo "Error: items.json not found at $ITEMS_PATH"
    exit 1
fi

# Read JSON files
ACCOUNTS=$(cat "$ACCOUNTS_PATH")
ITEMS=$(cat "$ITEMS_PATH")

# Validate seller exists
SELLER=$(echo "$ACCOUNTS" | jq ".[] | select(.id == $SELLER_ID)")
if [ -z "$SELLER" ]; then
    echo "Error: Seller with ID $SELLER_ID not found"
    exit 1
fi

# Validate buyer exists
BUYER=$(echo "$ACCOUNTS" | jq ".[] | select(.id == $BUYER_ID)")
if [ -z "$BUYER" ]; then
    echo "Error: Buyer with ID $BUYER_ID not found"
    exit 1
fi

# Validate item exists
ITEM=$(echo "$ITEMS" | jq ".[] | select(.id == $ITEM_ID)")
if [ -z "$ITEM" ]; then
    echo "Error: Item with ID $ITEM_ID not found"
    exit 1
fi

# Check if seller owns the item
SELLER_HAS_ITEM=$(echo "$SELLER" | jq ".myItems | contains([$ITEM_ID])")
if [ "$SELLER_HAS_ITEM" != "true" ]; then
    echo "Error: Seller (ID: $SELLER_ID) does not own item (ID: $ITEM_ID)"
    exit 1
fi

# Get item price and buyer balance
ITEM_PRICE=$(echo "$ITEM" | jq -r '.price' | sed 's/\$//g' | sed 's/,//g')
BUYER_BALANCE=$(echo "$BUYER" | jq -r '.accountBlanance')
SELLER_BALANCE=$(echo "$SELLER" | jq -r '.accountBlanance')

# Check if buyer has enough money
if (( $(echo "$BUYER_BALANCE < $ITEM_PRICE" | bc -l) )); then
    echo "Error: Buyer has insufficient funds"
    echo "Item price: \$$ITEM_PRICE, Buyer balance: \$$BUYER_BALANCE"
    exit 1
fi

# Calculate new balances
NEW_BUYER_BALANCE=$(echo "$BUYER_BALANCE - $ITEM_PRICE" | bc)
NEW_SELLER_BALANCE=$(echo "$SELLER_BALANCE + $ITEM_PRICE" | bc)

echo "Processing sale..."
echo "Item: $(echo "$ITEM" | jq -r '.name') (ID: $ITEM_ID)"
echo "Price: \$$ITEM_PRICE"
echo "Seller: ID $SELLER_ID (Balance: \$$SELLER_BALANCE -> \$$NEW_SELLER_BALANCE)"
echo "Buyer: ID $BUYER_ID (Balance: \$$BUYER_BALANCE -> \$$NEW_BUYER_BALANCE)"

# Update accounts JSON
UPDATED_ACCOUNTS=$(echo "$ACCOUNTS" | jq "
    map(
        if .id == $SELLER_ID then
            .myItems |= (. - [$ITEM_ID]) |
            .bookmarkedItems |= (. - [$ITEM_ID]) |
            .reservedItems |= (. - [$ITEM_ID]) |
            .itemsInCart |= (. - [$ITEM_ID]) |
            .accountBlanance = $NEW_SELLER_BALANCE
        elif .id == $BUYER_ID then
            .myItems |= (. + [$ITEM_ID] | unique) |
            .itemsInCart |= (. - [$ITEM_ID]) |
            .reservedItems |= (. - [$ITEM_ID]) |
            .accountBlanance = $NEW_BUYER_BALANCE
        else
            # Remove item from other users' carts, bookmarks, and reserved items
            .itemsInCart |= (. - [$ITEM_ID]) |
            .bookmarkedItems |= (. - [$ITEM_ID]) |
            .reservedItems |= (. - [$ITEM_ID])
        end
    )
")

# Write updated accounts back to file
echo "$UPDATED_ACCOUNTS" | jq '.' > "$ACCOUNTS_PATH"

echo "✓ Sale completed successfully!"
echo "✓ Item $ITEM_ID transferred from user $SELLER_ID to user $BUYER_ID"
echo "✓ Item removed from all carts, bookmarks, and reserved lists"