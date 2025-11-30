import json
import sys
from pathlib import Path

def change_password(username, new_password):

    python_script = Path(__file__).resolve()
    script_directory = python_script.parent
    ACCOUNT_PATH = script_directory.parent.parent /'json'/'accounts.json'
    # first, open our accounts
    selected_account = None
    local_accounts = []
    try:
        with open(ACCOUNT_PATH,'r') as accounts:
            local_accounts = json.load(accounts)
        
        for user in local_accounts:
            if user.get("username") == username:
                #account_id = user.get("id")
                user["password"] = new_password
                break
                
        with open(ACCOUNT_PATH, 'w') as account_file:
            json.dump(local_accounts, account_file, indent=2)

        response = {
            "result" : "Password reset success!"
        }
        
        return response
    
    except Exception:
        print(Exception)
        exit(0)





username = sys.argv[1]
new_password = sys.argv[2]


response = change_password(username, new_password)
response_json = json.dumps(response)

print(response_json)
sys.stdout.flush()
sys.exit(0)