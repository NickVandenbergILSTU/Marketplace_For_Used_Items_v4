import json
import sys
from pathlib import Path


def verify_username(entered_username):
    python_script = Path(__file__).resolve()
    script_directory = python_script.parent
    accounts_path = script_directory.parent.parent /'json'/'accounts.json'
    # first, open our accounts
    with open(accounts_path, 'r') as accounts:
        data = json.load(accounts)
    
    for key in data:
        if (key['username'] == entered_username):
            # if we found the username within our accounts.json
            response = {
                "response" : "Username was found",
                "username": entered_username,
            }
            response_json = json.dumps(response)
            print(response_json)
            sys.stdout.flush()
            return
        
    response = {
        "response" : "Username not found"
    }
    response_json = json.dumps(response)
    print(response_json)
    sys.stdout.flush()
        
username_to_check = sys.argv[1]
#username_to_check = 'thaterickid'

verify_username(username_to_check)