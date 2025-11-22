import json
import sys

def change_password(username, new_password):
    # first, open our accounts
    selected_account = None
    data = []
    with open('C:\\Users\\harbo\\Desktop\Marketplace_For_Used_Items\\Marketplace_For_Used_Items_v4\\json\\accounts.json','r') as accounts:
        data = json.load(accounts)
    for user in data:
        if user.get("username") == username:
            #account_id = user.get("id")
            user["password"] = new_password
            
    with open('C:\\Users\\harbo\\Desktop\Marketplace_For_Used_Items\\Marketplace_For_Used_Items_v4\\json\\accounts.json','w') as account_file:
        json.dump(data, account_file, indent=4)

    response = {
        "result" : "Password reset success!"
    }
    
    response_json = json.dumps(response)
    print(response_json)
    sys.stdout.flush()





username = sys.argv[1]
new_password = sys.argv[2]

change_password(username, new_password)