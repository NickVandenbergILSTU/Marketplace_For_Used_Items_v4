#!/bin/bash
# sell_item_to_store.sh - Transfer item ownership from seller to the store.
# Seller will transfer item ownership to the store (locations.sh), the store will add funds
# to the seller account proportional to the original price of the item
# and the store will own the item (look at item id array).

# Get input parameters from command line arguments
SELLER_ID=$1
ITEM_ID=$2
STORE_ID=$3

# Path to JSON files in the json directory
LOCATIONS_FILE="json/locations.json"
ITEMS_FILE="json/items.json"
ACCOUNTS_FILE="json/accounts.json"

# Path to Python script
PYTHON_SCRIPT="helper_scripts/add_numbers.py"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Please install jq to continue."
    exit 1
fi

# Check if Python is installed
if ! command -v python &> /dev/null; then
    echo "Error: python is required but not installed. Please install python to continue."
    exit 1
fi

# Check if required files exist
if [[ ! -f "$LOCATIONS_FILE" ]]; then
    echo "Error: locations.json not found at $LOCATIONS_FILE"
    exit 1
fi

if [[ ! -f "$ITEMS_FILE" ]]; then
    echo "Error: items.json not found at $ITEMS_FILE"
    exit 1
fi

if [[ ! -f "$ACCOUNTS_FILE" ]]; then
    echo "Error: accounts.json not found at $ACCOUNTS_FILE"
    exit 1
fi

if [[ ! -f "$PYTHON_SCRIPT" ]]; then
    echo "Error: add_numbers.py not found at $PYTHON_SCRIPT"
    exit 1
fi

# Check if correct number of arguments provided
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <seller_account_id> <item_id> <store_id>"
    echo "Example: $0 1 2 1"
    exit 1
fi


# Validate inputs
if [[ ! "$SELLER_ID" =~ ^[0-9]+$ ]] || [[ ! "$ITEM_ID" =~ ^[0-9]+$ ]] || [[ ! "$STORE_ID" =~ ^[0-9]+$ ]]; then
    echo "Error: All IDs must be numeric"
    exit 1
fi

# Check if seller account exists
SELLER_EXISTS=$(jq --argjson id "$SELLER_ID" 'any(.[]; .id == $id)' "$ACCOUNTS_FILE")
if [[ "$SELLER_EXISTS" != "true" ]]; then
    echo "Error: Seller account ID $SELLER_ID does not exist"
    exit 1
fi

# Check if item exists
ITEM_EXISTS=$(jq --argjson id "$ITEM_ID" 'any(.[]; .id == $id)' "$ITEMS_FILE")
if [[ "$ITEM_EXISTS" != "true" ]]; then
    echo "Error: Item ID $ITEM_ID does not exist"
    exit 1
fi

# Check if store exists
STORE_EXISTS=$(jq --argjson id "$STORE_ID" 'any(.[]; .id == $id)' "$LOCATIONS_FILE")
if [[ "$STORE_EXISTS" != "true" ]]; then
    echo "Error: Store ID $STORE_ID does not exist"
    exit 1
fi

# Check if seller owns the item
SELLER_OWNS_ITEM=$(jq --argjson sellerId "$SELLER_ID" --argjson itemId "$ITEM_ID" '
    any(.[]; .id == $sellerId and (.myItems // [] | any(. == $itemId)))
' "$ACCOUNTS_FILE")

if [[ "$SELLER_OWNS_ITEM" != "true" ]]; then
    echo "Error: Seller account ID $SELLER_ID does not own item ID $ITEM_ID"
    exit 1
fi

# Check if store already owns the item
STORE_OWNS_ITEM=$(jq --argjson storeId "$STORE_ID" --argjson itemId "$ITEM_ID" '
    any(.[]; .id == $storeId and (.storeItems // [] | any(. == $itemId)))
' "$LOCATIONS_FILE")

if [[ "$STORE_OWNS_ITEM" == "true" ]]; then
    echo "Error: Store ID $STORE_ID already owns item ID $ITEM_ID"
    exit 1
fi

# Get item price
ITEM_PRICE=$(jq -r --argjson id "$ITEM_ID" '.[] | select(.id == $id) | .price' "$ITEMS_FILE")
# Remove $ and convert to number
ITEM_PRICE_NUM=$(echo "$ITEM_PRICE" | sed 's/\$//g')

#echo ""
#echo "Transaction Details:"
#echo "  Seller: Account ID $SELLER_ID"
#echo "  Item: ID $ITEM_ID"
#echo "  Price: $ITEM_PRICE"
#echo "  Store: ID $STORE_ID"
#echo ""

# Get current seller balance
SELLER_BALANCE=$(jq -r --argjson id "$SELLER_ID" '.[] | select(.id == $id) | .accountBlanance // 0' "$ACCOUNTS_FILE")
# Balance is already a number in the JSON, no need to remove $
SELLER_BALANCE_NUM="$SELLER_BALANCE"

# Calculate new balance using Python script
NEW_BALANCE=$(python "$PYTHON_SCRIPT" "$SELLER_BALANCE_NUM" "$ITEM_PRICE_NUM")


# Remove item from seller's myItems array and update balance
jq --argjson sellerId "$SELLER_ID" --argjson itemId "$ITEM_ID" --argjson newBalance "$NEW_BALANCE" '
    map(if .id == $sellerId then
        .myItems = ((.myItems // []) | map(select(. != $itemId))) |
        .accountBlanance = $newBalance
    else . end)
' "$ACCOUNTS_FILE" > "$ACCOUNTS_FILE.tmp" && mv "$ACCOUNTS_FILE.tmp" "$ACCOUNTS_FILE"

# Add item to store's storeItems array
jq --argjson storeId "$STORE_ID" --argjson itemId "$ITEM_ID" '
    map(if .id == $storeId then
        .storeItems = ((.storeItems // []) + [$itemId] | unique)
    else . end)
' "$LOCATIONS_FILE" > "$LOCATIONS_FILE.tmp" && mv "$LOCATIONS_FILE.tmp" "$LOCATIONS_FILE"