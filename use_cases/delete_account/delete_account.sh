#!/bin/bash

# Script to delete your own account from accounts.json


JSON_FILE="accounts.json"


# Temp Login function  
login() {
    if [ -z "$ACCOUNT_ID" ]; then
        echo "No account is currently logged in."
            
        

        read -p "Username: " USERNAME
        read -s -p "Password: " PASSWORD
        echo ""
        
        # Verify
        ACCOUNT=$(jq --arg user "$USERNAME" --arg pass "$PASSWORD" \
            '.[] | select(.username == $user and .password == $pass)' "$JSON_FILE")
        
        if [ -z "$ACCOUNT" ]; then
            echo "Invalid username or password"
            exit 1
        fi
        
        # Extract account details
        ACCOUNT_ID=$(echo "$ACCOUNT" | jq -r '.id')
        ACCOUNT_BALANCE=$(echo "$ACCOUNT" | jq -r '.accountBlanance')

    else
        echo "Already logged in with account ID: $ACCOUNT_ID"
    fi
    
    
}



# Delete account function
delete_account() {
    echo -e " WARNING: Account deletion is permanent!"
    echo ""
    
    # First confirmation
    read -p "Type your password to confirm: " CONFIRM_PASSWORD
    
    if [ "$CONFIRM_PASSWORD" != "$PASSWORD" ]; then
        exit 0
    fi
    
    # Second confirmation
    read -p "Are you absolutely sure? Type 'DELETE' in capital letters: " CONFIRM_DELETE
    
    if [ "$CONFIRM_DELETE" != "DELETE" ]; then
        echo -e "Account deletion cancelled"
        exit 0
    fi
    
    
    if jq --argjson id "$ACCOUNT_ID" '[.[] | select(.id != $id)]' "$JSON_FILE" > "${JSON_FILE}.tmp"; then
        mv "${JSON_FILE}.tmp" "$JSON_FILE"
        echo ""
        echo -e "Account successfully deleted!"
        echo ""
        echo "Your account has been permanently removed."
    else
        echo -e "Failed to delete account"
        rm -f "${JSON_FILE}.tmp"
        exit 1
    fi

    delete_account_item
}



#deletes any item that may have the users id number
delete_account_item()
{
    ITEMS_FILE="items.json"

    if [ ! -f "$ITEMS_FILE" ]; then
        echo "Items file not found."
        exit 1
    fi

    if jq --argjson id "$ACCOUNT_ID" '
        map(
            .ratings = (.ratings // [] | map(select(.accountId != $id))) |
            .itemComments = (.itemComments // [] | map(select(.commenterId != $id)))
        )
    ' "$ITEMS_FILE" > "${ITEMS_FILE}.tmp"; then
        mv "${ITEMS_FILE}.tmp" "$ITEMS_FILE"
        echo "Items and comments deleted"
    else
        echo "Failed to update items."
        rm -f "${ITEMS_FILE}.tmp"
        exit 1
    fi
}


clear
login
echo ""
delete_account