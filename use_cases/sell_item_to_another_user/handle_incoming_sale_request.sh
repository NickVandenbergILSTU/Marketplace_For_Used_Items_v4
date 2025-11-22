#!/bin/bash

# Script: handle_sale_request.sh
# Purpose: Accept or reject incoming sale requests
# Parameters: $1 = "accept" or "reject", $2 = item_id

ACTION=$1
ITEM_ID=$2

# Path to JSON files
LOCAL_DATA_JSON="./json/local/local_data.json"
ACCOUNTS_JSON="./json/accounts.json"

# Validate parameters
if [ -z "$ACTION" ] || [ -z "$ITEM_ID" ]; then
    echo "Error: Missing required parameters. Usage: handle_sale_request.sh <accept|reject> <item_id>"
    exit 1
fi

# Validate action parameter
if [ "$ACTION" != "accept" ] && [ "$ACTION" != "reject" ]; then
    echo "Error: Action must be 'accept' or 'reject'"
    exit 1
fi

# Get currently logged in user ID
CURRENT_USER_ID=$(jq -r '.currentlyLoggedInUserID' "$LOCAL_DATA_JSON")

if [ "$CURRENT_USER_ID" == "null" ] || [ "$CURRENT_USER_ID" == "-1" ]; then
    echo "Error: No user is currently logged in."
    exit 1
fi

# Get the source user ID from the incoming sale request before removing it
SOURCE_USER_ID=$(jq --arg uid "$CURRENT_USER_ID" --arg iid "$ITEM_ID" \
    '.[] | select(.id == ($uid | tonumber)) | 
    .incomingSaleRequests[] | select(.itemId == ($iid | tonumber)) | 
    .sourceUserId' "$ACCOUNTS_JSON")

if [ -z "$SOURCE_USER_ID" ] || [ "$SOURCE_USER_ID" == "null" ]; then
    echo "Error: Sale request not found for this item."
    exit 1
fi

# Remove the item from the logged in user's incomingSaleRequests array
jq --arg uid "$CURRENT_USER_ID" --arg iid "$ITEM_ID" \
    'map(if .id == ($uid | tonumber) then 
        .incomingSaleRequests |= map(select(.itemId != ($iid | tonumber)))
    else . end)' \
    "$ACCOUNTS_JSON" > "${ACCOUNTS_JSON}.tmp" && mv "${ACCOUNTS_JSON}.tmp" "$ACCOUNTS_JSON"

# Remove the item from the source user's outgoingSaleRequests array
jq --arg suid "$SOURCE_USER_ID" --arg tid "$CURRENT_USER_ID" --arg iid "$ITEM_ID" \
    'map(if .id == ($suid | tonumber) then 
        .outgoingSaleRequests |= map(select(not (.targetUserId == ($tid | tonumber) and .itemId == ($iid | tonumber))))
    else . end)' \
    "$ACCOUNTS_JSON" > "${ACCOUNTS_JSON}.tmp" && mv "${ACCOUNTS_JSON}.tmp" "$ACCOUNTS_JSON"

# If action is "accept", add the item to the logged in user's myItems array
if [ "$ACTION" == "accept" ]; then
    # Get item price for the transaction
    ITEM_PRICE=$(jq -r --arg iid "$ITEM_ID" \
        '.[] | select(.id == ($iid | tonumber)) | .price' \
        "./json/items.json")
    
    # Remove currency symbols and extract numeric value
    NUMERIC_PRICE=$(echo "$ITEM_PRICE" | sed 's/[^0-9.]//g')
    
    
    # Get buyer's current balance
    BUYER_BALANCE=$(jq -r --arg uid "$CURRENT_USER_ID" \
        '.[] | select(.id == ($uid | tonumber)) | 
        if .accountBalance then .accountBalance else .accountBlanance end' \
        "$ACCOUNTS_JSON")
    
    # Check if buyer has sufficient funds
    BUYER_BALANCE_NUM=$(echo "$BUYER_BALANCE" | sed 's/[^0-9.]//g')
    if ! [[ "$BUYER_BALANCE_NUM" =~ ^[0-9]+\.?[0-9]*$ ]]; then
        BUYER_BALANCE_NUM=0
    fi
    
    # Compare balances using bc for floating point arithmetic
    # if (( $(echo "$BUYER_BALANCE_NUM < $NUMERIC_PRICE" | bc -l) )); then
    #     echo "Error: Insufficient funds. You need \$NUMERIC_PRICE but only have \$BUYER_BALANCE_NUM."
    #     exit 1
    # fi
    
    # Check if user already owns the item
    ALREADY_OWNS=$(jq --arg uid "$CURRENT_USER_ID" --arg iid "$ITEM_ID" \
        '.[] | select(.id == ($uid | tonumber)) | .myItems | contains([($iid | tonumber)])' \
        "$ACCOUNTS_JSON")
    
    if [ "$ALREADY_OWNS" != "true" ]; then
        # Add item to current user's myItems
        jq --arg uid "$CURRENT_USER_ID" --arg iid "$ITEM_ID" \
            'map(if .id == ($uid | tonumber) then 
                .myItems += [($iid | tonumber)]
            else . end)' \
            "$ACCOUNTS_JSON" > "${ACCOUNTS_JSON}.tmp" && mv "${ACCOUNTS_JSON}.tmp" "$ACCOUNTS_JSON"
    fi
    
    # Remove item from source user's myItems
    jq --arg suid "$SOURCE_USER_ID" --arg iid "$ITEM_ID" \
        'map(if .id == ($suid | tonumber) then 
            .myItems |= map(select(. != ($iid | tonumber)))
        else . end)' \
        "$ACCOUNTS_JSON" > "${ACCOUNTS_JSON}.tmp" && mv "${ACCOUNTS_JSON}.tmp" "$ACCOUNTS_JSON"
    
    # Deduct price from buyer's account
    jq --arg uid "$CURRENT_USER_ID" --arg price "$NUMERIC_PRICE" \
        'map(if .id == ($uid | tonumber) then 
            if .accountBalance then 
                .accountBalance = ((.accountBalance | tonumber) - ($price | tonumber))
            else 
                .accountBlanance = ((.accountBlanance | tonumber) - ($price | tonumber))
            end
        else . end)' \
        "$ACCOUNTS_JSON" > "${ACCOUNTS_JSON}.tmp" && mv "${ACCOUNTS_JSON}.tmp" "$ACCOUNTS_JSON"
    
    # Add price to seller's account
    jq --arg suid "$SOURCE_USER_ID" --arg price "$NUMERIC_PRICE" \
        'map(if .id == ($suid | tonumber) then 
            if .accountBalance then 
                .accountBalance = ((.accountBalance | tonumber) + ($price | tonumber))
            else 
                .accountBlanance = ((.accountBlanance | tonumber) + ($price | tonumber))
            end
        else . end)' \
        "$ACCOUNTS_JSON" > "${ACCOUNTS_JSON}.tmp" && mv "${ACCOUNTS_JSON}.tmp" "$ACCOUNTS_JSON"
    
    # Get item name for success message
    ITEM_NAME=$(jq -r --arg iid "$ITEM_ID" \
        '.[] | select(.id == ($iid | tonumber)) | .name' \
        "./json/items.json")
    
    echo "Success: Sale request accepted. Item '${ITEM_NAME}' has been added to your items. You paid \$NUMERIC_PRICE."
else
    # Get item name for rejection message
    ITEM_NAME=$(jq -r --arg iid "$ITEM_ID" \
        '.[] | select(.id == ($iid | tonumber)) | .name' \
        "./json/items.json")
    
    echo "Success: Sale request for item '${ITEM_NAME}' has been rejected."
fi

exit 0