#!/usr/bin/env python3

import json
import sys
import os

LOCAL_DATA_FILE = "json/local/local_data.json"
ACCOUNTS_FILE = "json/accounts.json"
ITEMS_FILE = "json/items.json"

# Check if files exist
if not os.path.exists(LOCAL_DATA_FILE):
    print(f"Error: {LOCAL_DATA_FILE} not found")
    sys.exit(1)

if not os.path.exists(ACCOUNTS_FILE):
    print(f"Error: {ACCOUNTS_FILE} not found")
    sys.exit(1)

if not os.path.exists(ITEMS_FILE):
    print(f"Error: {ITEMS_FILE} not found")
    sys.exit(1)

# Load JSON files
with open(LOCAL_DATA_FILE, 'r') as f:
    local_data = json.load(f)

with open(ACCOUNTS_FILE, 'r') as f:
    accounts = json.load(f)

with open(ITEMS_FILE, 'r') as f:
    items = json.load(f)

# Get currently logged in user ID
current_user_id = local_data.get('currentlyLoggedInUserID')

if current_user_id is None:
    print("Error: No user currently logged in")
    sys.exit(1)

# Find the current user's account
user_account = None
for account in accounts:
    if account['id'] == current_user_id:
        user_account = account
        break

if user_account is None:
    print(f"Error: User with ID {current_user_id} not found")
    sys.exit(1)

# Get account balance and cart items
account_balance = user_account.get('accountBalance', 0)
cart_items = user_account.get('itemsInCart', [])

if not cart_items:
    print("Cart is empty")
    print("Total: $0.00")
    print(f"Account Balance: ${account_balance:.2f}")
    sys.exit(0)

# Calculate total price
total = 0.0
print("Items in cart:")
print("-" * 40)

for item_id in cart_items:
    # Find the item in items.json
    item = None
    for i in items:
        if i['id'] == item_id:
            item = i
            break
    
    if item is None:
        print(f"Warning: Item ID {item_id} not found in items.json")
        continue
    
    item_name = item['name']
    item_price_str = item['price']
    
    # Remove $ and convert to float
    item_price = float(item_price_str.replace('$', ''))
    
    print(f"  - {item_name}: ${item_price:.2f}")
    total += item_price

print("-" * 40)
print(f"Total: ${total:.2f}")
print(f"Account Balance: ${account_balance:.2f}")
print("-" * 40)

# Check if total exceeds balance
if total > account_balance:
    print("\nError: Cart total exceeds account balance!")
    sys.exit(1)
else:
    print("Sufficient funds available")
    sys.exit(0)