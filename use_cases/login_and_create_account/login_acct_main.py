

import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from account_handler import Account_Handler
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