import sys
import os
from python_classes.shopping_Cart import Shopping_Account

if len(sys.argv) != 3:
    print("Usage: python main.py <userID> <itemID>")
    sys.exit(1)

userID = sys.argv[1]
itemID = sys.argv[2]

handler = Shopping_Account()

handler.removeFromCart(userID, itemID)