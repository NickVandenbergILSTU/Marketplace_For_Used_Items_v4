import sys
import os
from python_classes.account_handler import Account_Handler

# Add python_classes folder to path (go up one level from use_cases/create_item, then into python_classes)
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

# make it so that the account handler's method for creating account is called with
# this parameter:
# password='$1'

# Create an Account_Handler instance that will check the provided password
account_handler = Account_Handler()

# Get command line arguments (expecting password after the script name)
if len(sys.argv) != 2:
    print("Usage: python main.py <password>")
    sys.exit(1)

password = sys.argv[1]

# Call the method
account_handler.checkPasswordRequirements(password)