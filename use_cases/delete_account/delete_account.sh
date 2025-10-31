#!/bin/bash

# Script to delete your own account from accounts.json


JSON_FILE="accounts.json"


# Temp Login function  
#if user is not logged in then you will be required to login
login() {
    if [ -z "$ACCOUNT_ID" ]; then
        echo "No account is currently logged in."
            
        

        read -p "Username: " USERNAME
        read -s -p "Password: " PASSWORD
        echo ""
        
        # Verify credentials
        ACCOUNT=$(jq --arg user "$USERNAME" --arg pass "$PASSWORD" \
            '.[] | select(.username == $user and .password == $pass)' "$JSON_FILE")
        
        if [ -z "$ACCOUNT" ]; then
            echo "✗ Login failed: Invalid username or password"
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

    
    # Warning messages
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
}

# Main execution
clear
login
echo ""
delete_account
