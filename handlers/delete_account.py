import json

def load_user_data(file_path='accounts.json'):
    try:
        with open(file_path, 'r') as file:
            return json.load(file)
    except FileNotFoundError:
        return {}
    except json.JSONDecodeError:
        return {}
    
def save_user_data(user_id, file_path='accounts.json'):
    with open(file_path, 'r') as file:
        json.dump(user_id, file, indent=4)

def find_user_index(user, user_id):
    for index, account in enumerate(user):
        if account['user_id'] == user_id:
            return index
    return -1

def delete_account(user_id, password, file_path='accounts.json'):
    user_data = load_user_data(file_path)
    
    user_index = find_user_index(user_data, user_id)
    
    if user_index == -1:
        return "Account not found."
    
    user = user_data[user_index]

    if password != user['password']:
        return "Incorrect password."   
    
    if not confirm_deletion( user.get(password)):
        print("Account deletion cancelled.")
        return False
    
    user.pop(user_index)
    save_user_data(user_data, file_path)
    print("Account successfully deleted.")
    return True

def confirm_deletion(password):
    print("\nAre you sure you want to delete the account?")
    confirm_password = input("Please enter your password to confirm: ")
    return confirm_password == password 
