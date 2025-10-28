#!/bin/bash

ACCOUNTS_FILE="json/accounts.json"
ITEMS_FILE="json/items.json"
LOCATIONS_FILE="json/locations.json"
LOCAL_DATA_FILE="json/local/local_data.json"

current_user_id=$(jq '.currentlyLoggedInUserID' "$LOCAL_DATA_FILE")

if [ "$current_user_id" -eq -1 ]; then
    echo "No user is currently logged in."
    exit 1
fi

user_account=$(jq --argjson id "$current_user_id" '.[] | select(.id == $id)' "$ACCOUNTS_FILE")

if [ -z "$user_account" ]; then
    echo "User account not found."
    exit 1
fi 

username =$(echo "$user_account" | jq -r '.username')
echo "Found account: $username (ID: $current_user_id)"

read -sp "Enter your password to confirm deletion: " password
echo ""

stored_password=$(echo "$user_account" | jq -r '.password')

if [ "$password" != "$stored_password" ]; then
    echo "Incorrect password."
    exit 1
fi

echo ""
echo "Your account will be deleted FOREVER"
echo "This will delete your account, items you listed, and all your stores."
echo ""

read -p "Are you sure you want to proceed? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Account deletion cancelled."
    exit 0
fi

read -sp "Re-enter your password to confirm deletion: " password_confirm
echo ""

if [ "$password_confirm" != "$stored_password" ]; then
    echo "Incorrect password."
    exit 1
fi

user_items=$(echo "$user_account" | jq -r '.myItems[]' 2>/dev/null)
user_stores=$(echo "$user_account" | jq -r '.ownedStores[]' 2>/dev/null)

tmp=$(mktemp)
jq --argjson id "$current_user_id" 'map(select(.id != $id))' "$ACCOUNTS_FILE" > "$tmp" && mv "$tmp" "$ACCOUNTS_FILE"

echo "Account deleted."

tmp=$(mktemp)
j1--argjson userId "$current_user_id" 
    map(

    .reservedItems = (.reservedItems - (. | [.myItems[] | select(. != null)] | map(select(. != null)))) |
    .itemsInCart = (.itemsInCart - (. | [.myItems[] | select(. != null)] | map(select(. != null))))
  ) 
   "$ACCOUNTS_FILE" > "$tmp" && mv "$tmp" "$ACCOUNTS_FILE"

  echo "✓ Cleaned up references to deleted user's items"

  if [ -n "$user_stores" ]; then
  tmp=$(mktemp)
  store_ids_array=$(echo "$user_stores" | jq -s '.')
  jq --argjson storeIds "$store_ids_array" 'map(select([.id] | inside($storeIds) | not))' "$LOCATIONS_FILE" > "$tmp" && mv "$tmp" "$LOCATIONS_FILE"
  echo "✓ Removed user's stores from locations.json"
fi

tmp=$(mktemp)
jq '.currentlyLoggedInUserID = -1' "$LOCAL_DATA_FILE" > "$tmp" && mv "$tmp" "$LOCAL_DATA_FILE"

echo "✓ Logged out user in local_data.json"

echo ""
echo "✓✓✓ Account '$username' has been successfully deleted! ✓✓✓"
echo ""