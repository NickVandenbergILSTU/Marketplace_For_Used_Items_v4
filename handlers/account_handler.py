import json
def getSecurityQuestion(username):
    with open('json/accounts.json', 'r') as file:
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

def get_user_exist(username):
    user_exists = False
    with open('json/accounts.json', 'r') as file:
        data = json.load(file)
    
    for user in data:
        if (user['username'] == username):
            user_exists = True

    if user_exists == True:
        #redirect to home page
        print('test')

username_to_check = 'thaterickid'
getSecurityQuestion(username_to_check)