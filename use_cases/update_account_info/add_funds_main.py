from python_classes.account_handler import Account_Handler
import sys

account_handler = Account_Handler()

if len(sys.argv) != 3:
    print("Usage: python add_funds_main.py <userID> <amount>")
    sys.exit(1)

userID = sys.argv[1]
amount = sys.argv[2]

account_handler.addFunds(userID, amount)