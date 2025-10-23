import json
import sys
def getSecurityQuestion(username):
    with open('json/possible_accounts_updated.json', 'r') as file:
        data = json.load(file)

    for user in data:
        if (user['username'] == username):
            #random.number = 0
            securityQuestion = user['security_q_a']
        
    #Check for the user within the account file
    # if (data['username'] == username):
    #     print(f'{username} is found!')
    # else:
    #     print(f'{username} IS NOT FOUND!')

def get_user_exist(username_to_check):
    user_exists = False
    with open('./json/accounts.json', 'r') as file:
        data = json.load(file)
    
    for info in data:
        if info['username'] == username_to_check:
            user_exists = True
            print('Account verified', flush=True)
            return True
            #sys.stdout.flush()
    
    if user_exists == False:
        print('User not found', flush=True)
        return False



def test_communication(entered_username):
    # first, open our accounts
    with open('../json/accounts.json', 'r') as accounts:
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
    
username_to_check = sys.argv[1]
#entered_username = "thaterickid"
test_communication(username_to_check)
#print(username_to_check)
#getSecurityQuestion(username_to_check)
#get_user_exist(username_to_check)
#print(user_exists)

# if __name__ == "__main__":
#     # sys.argv[0] is the script name itself, sys.argv[1] is the first argument (the username)
#     if len(sys.argv) > 1:
#         entered_username = sys.argv[1]
#         get_user_exist(entered_username)