import json
import sys
from pathlib import Path
import traceback


def add_to_cart(item_id):

    #load paths
    python_script = Path(__file__).resolve()
    
    script_directory = python_script.parent
    accounts_path = script_directory.parent.parent /'json'/'accounts.json'
    local_data_path = script_directory.parent.parent / 'json' / 'local' / 'local_data.json'

    local_data_dict = {}
    account_id = None
    data_from_accounts = []

    # attempt to open and edit the account file
    try:
        
        #open local data file
        with open(local_data_path, 'r') as local_data_file:
            local_data_dict = json.load(local_data_file)
        
        
        #attempt to find the account_id (will always come back true)
        for key in local_data_dict:
            if key == 'currentlyLoggedInUserID':
                account_id = local_data_dict[key]
        
        #attempt to open the accounts and load into local variable
        
        with open(accounts_path, 'r') as accounts:
            data_from_accounts = json.load(accounts)

        #find the account with the matching account_id
        #if found: verify item isn't already in shopping cart
        for user in data_from_accounts:
            if user.get('id') == account_id:
                if item_id in user.get('itemsInCart'):
                    print("Item alredy in cart")
                    return 0
                
                user.get('itemsInCart').append(item_id)
                break
                
    
    except Exception:
        print(traceback.format_exc())

    #attempt to edit the accounts.json file
    try:
        with open(accounts_path, 'w') as accounts_file:
            json.dump(data_from_accounts, accounts_file, indent=4)

        print("Item added to cart")
    except Exception:
        print(traceback.format_exc())
    

item_id = int(sys.argv[1])
add_to_cart(item_id)