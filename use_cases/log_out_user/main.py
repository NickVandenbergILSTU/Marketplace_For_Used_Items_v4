import sys
import os

# Add python_classes folder to path (go up one level from use_cases/create_item, then into python_classes)
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from account_handler import Account_Handler

# Create an account_handler instance
account_handler = Account_Handler()

# Call the method logoutUser
account_handler.logoutUser()