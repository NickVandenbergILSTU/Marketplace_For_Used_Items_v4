import json
import sys
from pathlib import Path

def change_password(username, new_password):
    # first, open our accounts
    python_script = Path(__file__).resolve()
    script_directory = python_script.parent
    accounts_path = script_directory.parent.parent /'json'/'accounts.json'

    selected_account = None
    data = []
    try: 
        with open(accounts_path,'r') as accounts:
        #with open('json/acounts.json', 'r') as accounts:
            data = json.load(accounts)
        
        for user in data:
            if user.get("username") == username:
                #account_id = user.get("id")
                user["password"] = new_password
                break
                
        with open(accounts_path,'w') as account_file:
            json.dump(data, account_file, indent=4)

        response = {
            "result" : "Password reset success!"
        }
        
        response_json = json.dumps(response)
        print(response_json)
        sys.stdout.flush()
    
    except:
        response = {
            "result" : "Error occured"
        }
        response_json = json.dumps(response)
        print(resposne_json)
        sys.stdout.flush()







username = sys.argv[1]
new_password = sys.argv[2]

change_password(username, new_password)