import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from account_handler import Account_Handler

# Create a User instance and delete account
account_handler = Account_Handler()
account_handler.deleteAccount()