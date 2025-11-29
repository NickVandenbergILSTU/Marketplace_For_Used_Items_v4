from python_classes.account_handler import Account_Handler
import sys

# Create an account handler object
account_handler = Account_Handler()

# Expect exactly 2 parameters
if len(sys.argv) != 3:
    print("Usage: python main_login.py <username> <password>")
    sys.exit(1)

username = sys.argv[1]
password = sys.argv[2]

# Call the loginUser method
account_handler.loginUser(username, password)