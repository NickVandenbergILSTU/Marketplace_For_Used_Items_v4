import json
import sys
from pathlib import Path
import traceback


def add_to_cart(item_id):

    #load the account.json
    python_script = Path(__file__).resolve()
    #print(f'Python Script location: {python_script}')
    script_directory = python_script.parent
    #print(f'Python script directory: {script_directory}')
    accounts_path = script_directory.parent.parent /'json'/'accounts.json'
    local_data_path = script_directory.parent.parent / 'json' / 'local' / 'local_data.json'
    #print(f'Local data location: {local_data}')
    
    #pull the current logged in account
    try:
        local_data_dict = {}
        account_id = None
        
        with open(local_data_path, 'r') as local_data_file:
            local_data_dict = json.load(local_data_file)
        
        
        #print(f'Local data:\n {local_data_dict}')
        # for key, data in local_data_dict:
        #     if (key == 'currentlyLoggedInUserID'):
        #         account_id = data

        for key in local_data_dict:
            if key == 'currentlyLoggedInUserID':
                account_id = local_data_dict[key]
                print(f'User ID: {account_id}')
        
        selected_account = None
        data = []
        cart = []

    
        with open(accounts_path, 'r') as accounts:
            data = json.load(accounts)


        for user in data:
            if user.get('id') == account_id:
                print(f'User cart: {user.get('itemsInCart')}')
                user.get('itemsInCart').append(item_id)
                print(f'Cart after: {user.get('itemsInCart')}')


        with open(accounts_path, 'w') as accounts_file:
            json.dump(data, accounts_file, indent=4)
        
    
    except Exception:
        print(traceback.format_exc())

item_id = int(sys.argv[1])
add_to_cart(item_id)