#### ASSUMPTIONS ###
### 1. the user has enough money in their account
### 2. the user enters the correct address

### we need:
# user (preferably the object)
# their shopping cart
#

import sys
import json
from pathlib import Path

def run():
    python_script = Path(__file__).resolve()
    script_directory = python_script.parent

    # Load account_id from local_data.json
    LOCAL_DATA_PATH = script_directory.parent.parent / 'json' / 'local' / 'local_data.json'
    with open(LOCAL_DATA_PATH, 'r') as local_data_file:
        local_data = json.load(local_data_file)
        account_id = local_data.get("currentlyLoggedInUserID")

    ITEM_PATH = script_directory.parent.parent /'json'/'items.json'
    ACCOUNT_PATH = script_directory.parent.parent /'json'/'accounts.json'
    STORE_PATH = script_directory.parent.parent / 'json'/'locations.json'

    #1. Make sure each item in the shopping cart isn't reserved by someone else
    # if it is, return error with what item is reserved

    local_accounts = None
    selected_account = None

    with open(ACCOUNT_PATH, 'r') as accounts:
        local_accounts = json.load(accounts)

    for user in local_accounts:
        if user.get("id") == account_id:
            #account_id = user.get("id")
            selected_account = user
            break

    shopping_cart = selected_account['itemsInCart']
    if len(shopping_cart) == 0:
        return 'Shopping cart is empty'
    #print(f'Items in your shopping cart: {shopping_cart}')

    local_items = None
    with open(ITEM_PATH, 'r') as items:
        local_items = json.load(items)

    reservedItems = []
    for item_in_cart in shopping_cart:
        for user in local_accounts:
            #print(user)
            if item_in_cart in user['reservedItems']:
                reservedItems.append(item_in_cart)
            


    # for item in local_items:
    #     for item_in_cart in shopping_cart:
    #         #print(f'Item in cart: {item_in_cart}')
    #         #total_cost += item_in_cart
    #         if item.get("id") == item_in_cart:
    #             if not item.get("reservedBy") == account_id: # check if the item is reserved
    #                 reservedItems.append(item.get("id"))

    if not len(reservedItems) == 0:
        return (f'The following item are on reserve by others: {reservedItems} ')
        print(f'The following items are on reserve by others: {reservedItems} ')
        exit(1)

    # Step 2: calculate the total of all items in shopping cart
    total_cost = 0.00
    for item_in_cart in shopping_cart:
        for item in local_items:
            if item['id'] == item_in_cart:
                item_cost = float(item['price'].replace('$', ''))
                total_cost += item_cost
                break

    # for item in local_items:
    #     for item_in_cart in shopping_cart:
    #         if item['id'] == item_in_cart:
    #             item_cost = float(item['price'].replace("$",""))
    #             total_cost += item_cost

    print(total_cost)

    # Step 3: verify that the user has enough money on their account
    if selected_account.get('accountBalance') < total_cost:
        return 'You do not have enough money to cover this balance'
        # print('You do not have enough money to cover this balance.')
        # exit(1)

    # Step 4: if all checks have gone through, update the account balance, item owner, remove from store

    #update account balance
    selected_account['accountBalance'] = selected_account['accountBalance'] - total_cost

    #add item to order history
    selected_account['orderHistory'].append(shopping_cart)

    # remove items from each store
    with open(STORE_PATH, 'r') as stores_file:
        stores = json.load(stores_file)

    # remove item from the store
    for store in stores:
        #print(store)
        #print(f'Store stock before update: {store['storeItems']}')
        for item in shopping_cart:
            if item in store['storeItems']:
                store['storeItems'].remove(item) # successfully updates the store
                break
        #print(f'Store stock after update: {store['storeItems']}')

    for user in local_accounts:
        print(f'{user['username']} items before update: {user['myItems']}')
        for item in shopping_cart:
            if item in user['myItems'] and not user['id'] == account_id:
                user['myItems'].remove(item)
            if item in user['bookmarkedItems'] and not user['id'] == account_id:    
                user['bookmarkedItem'].remove(item)
            
            #add the item to myItems, remove from shopping cart
            if user['id'] == account_id:
                user['myItems'].append(item)
                user['itemsInCart'].remove(item)
                user['reservedItems'].remove(item)
        #print(f'{user['username']} items after update: {user['myItems']}\n')

    return 'Success'

result = run()
if 'Success' in result:
    sys.exit(0)
else:
    print(result)
    sys.exit(1)
#finally, update each json file to reflect the new items
### Accounts ####

