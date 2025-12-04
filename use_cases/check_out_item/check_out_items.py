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
import traceback
import copy
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from item import Item

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
            
            selected_account = user
            break

    shopping_cart = selected_account['itemsInCart']
    order_history_shopping_cart = copy.deepcopy(selected_account['itemsInCart'])
    if len(shopping_cart) == 0:
        return 'Shopping cart is empty'
   

    local_items = None
    with open(ITEM_PATH, 'r') as items:
        local_items = json.load(items)

    reservedItems = []
    for item_in_cart in shopping_cart:
        for user in local_accounts:
            #print(user)
            if item_in_cart in user['reservedItems'] and not user['id'] == account_id:
                reservedItems.append(item_in_cart)
                break
            


    if not len(reservedItems) == 0:
        return (f'The following item are on reserve by others: {reservedItems} ')


    # Step 2: calculate the total of all items in shopping cart
    total_cost = 0.00
    for item_in_cart in shopping_cart:
        for item in local_items:
            if item['id'] == item_in_cart:
                item_cost = float(item['price'].replace('$', ''))
                total_cost += item_cost
                break

    # Step 3: verify that the user has enough money on their account
    if selected_account.get('accountBalance') < total_cost:
        return 'You do not have enough money to cover this balance'


    # Step 4: if all checks have gone through, update the account balance, item owner, remove from store

    #update account balance
    selected_account['accountBalance'] = selected_account['accountBalance'] - total_cost

    #add item to order history
    #print(shopping_cart)
    
    
    

    itemArray = []
    # create item objects
    for item in shopping_cart:
        #print(item)
        for itemsDB in local_items:
            #rint(itemsDB)
            if item == itemsDB['id']:
                item_id = itemsDB['id']
                item_name = itemsDB['name']
                item_price = itemsDB['price']
                #Create item
                myItem = Item()
                myItem.id = item_id
                myItem.name = item_name
                myItem.price = item_price
                #add to dictionary
                itemArray.append(myItem)
                break

    #print(itemArray)

    # remove items from each store
    with open(STORE_PATH, 'r') as stores_file:
        stores = json.load(stores_file)

    # remove item from the store
    for store in stores:
        
        
        for item in shopping_cart:
            if item in store['storeItems']:
                store['storeItems'].remove(item) # successfully updates the store
                break
        

    for user in local_accounts:
        
        for item in shopping_cart:
            if item in user['myItems'] and not user['id'] == account_id:
                user['myItems'].remove(item)
            if item in user['bookmarkedItems'] and not user['id'] == account_id:    
                user['bookmarkedItem'].remove(item)
            
            #add the item to myItems, remove from shopping cart
            if user['id'] == account_id:
                user['myItems'].append(item)
                if item in user['reservedItems']:
                    user['reservedItems'].remove(item)
        
        

        if user['id'] == account_id:
            for item in itemArray:
                user['orderHistory'].append({"id": item.id, "name" : item.name, "price" : item.price})
            user['itemsInCart'] = []

    

    #now write back to the proper files
    try:
        with open(ACCOUNT_PATH, 'w') as accounts_file:
            json.dump(local_accounts, accounts_file, indent=2)

        with open(STORE_PATH, 'w') as store_file:
            json.dump(stores, store_file, indent=2)

    except Exception:
        print(traceback.format_exc())

    return 'Success'

result = run()
if 'Success' in result:
    print('Success')
    sys.exit(0)
else:
    print(result, file=sys.stdout)