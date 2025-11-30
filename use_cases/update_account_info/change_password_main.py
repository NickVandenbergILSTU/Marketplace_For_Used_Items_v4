import sys
import os
from python_classes.account_handler import Account_Handler

if len(sys.argv) != 3:
    print("Usage: python main.py <userID> <newPassword>")
    sys.exit(1)

userID = sys.argv[1]
newPassword = sys.argv[2]

handler = Account_Handler()

handler.updatePassword(userID, newPassword)