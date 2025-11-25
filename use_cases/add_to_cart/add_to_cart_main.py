import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))
from item import Item
from shopping_Cart import Shopping_Account
from user import User

#create item object
item = Item()
item.itemID = int(sys.argv[1])

#create shoppping cart object
cart = Shopping_Account()

#add the item to the user's cart
result = cart.addToShoppingCart(item.itemID)
print(result)

