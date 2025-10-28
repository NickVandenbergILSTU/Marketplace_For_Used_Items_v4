import json
import sys

def verify_username(entered_username):
    # first, open our accounts
    with open('C:\\Users\\harbo\\Desktop\\Marketplace_For_Used_Items\\Marketplace_For_Used_Items_v4\\json\\accounts.json', 'r') as accounts:
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

verify_username(username_to_check)