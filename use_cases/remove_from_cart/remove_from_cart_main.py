import sys
import os

# Add python_classes folder to path (go up one level from use_cases/create_item, then into python_classes)
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from shopping_Cart import Shopping_Account

if len(sys.argv) != 3:
    print("Usage: python main.py <userID> <itemID>")
    sys.exit(1)

userID = sys.argv[1]
itemID = sys.argv[2]

handler = Shopping_Account()

handler.removeFromShoppingCart(userID, itemID)