# import Account_Handler from python_classes/account_handler.py
# import User from python_classes/user.py

# create a user obect
# create an account handler object with the user object instantiated in the accountArray

# make it so that the account handler's method for creating account is called with
# these params:
# username="$1"
# password="$2"
# password2="$3"
# email="$4"
# securityQuestion="$5"
# securityAnswer="$6"

from python_classes.account_handler import Account_Handler
from python_classes.user import User
import sys

# Create a user object
user = User()

# Create an account handler object with the user object in the accountArray
account_handler = Account_Handler()
account_handler.accountArray.append(user)

# Get command line arguments (expecting 6 arguments after the script name)
if len(sys.argv) != 7:
    print("Usage: python main.py <username> <password> <password2> <email> <securityQuestion> <securityAnswer>")
    sys.exit(1)

username = sys.argv[1]
password = sys.argv[2]
password2 = sys.argv[3]
email = sys.argv[4]
securityQuestion = sys.argv[5]
securityAnswer = sys.argv[6]

# Call the createAccount method with the parameters
# Note: You'll need to modify the Account_Handler.createAccount() method
# to accept these parameters and pass them to the shell script
account_handler.createAccount(username, password, password2, email, securityQuestion, securityAnswer)