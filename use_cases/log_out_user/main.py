import sys
import os

# Add python_classes folder to path (go up one level from use_cases/create_item, then into python_classes)
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from account_handler import Account_Handler
from user import User

# Create an account_handler instance with a user in the array
account_handler = Account_Handler()
user = User()
account_handler.accountArray.append(user)

# Call the method logoutUser
account_handler.logoutUser()