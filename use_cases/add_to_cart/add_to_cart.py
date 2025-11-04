import json
import sys
from pathlib import Path


def add_to_cart(account_id, item_id):

    #load the account.json
    python_script = Path(__file__).resolve()
    script_directory = python_script.parent
    accounts_path = script_directory.parent.parent /'json'/'accounts.json'

    selected_account = None
    data = []
    cart = []

    try:
        with open(accounts_path, 'r') as accounts:
            data = json.load(accounts)


        for user in data:
            if user.get('id') == account_id:
                print(f'User cart: {user.get('itemsInCart')}')
                user.get('itemsInCart').append(item_id)
                print(f'Cart after: {user.get('itemsInCart')}')


        with open(accounts_path, 'w') as accounts_file:
            json.dump(data, accounts_file, indent=4)
        
    
    except:
        print("Error occurred")

account_id = int(sys.argv[1])
item_id= int(sys.argv[2])
add_to_cart(account_id, item_id)