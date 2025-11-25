import sys
import os

# Add python_classes folder to path (go up one level from use_cases/create_item, then into python_classes)
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from python_classes.userItem import UserItem
from python_classes.item import Item

# make it so that the userItem's method for selling an item to the store is called with
# these params:
# sellerID="$1"
# itemID="$2"
# storeID="$3"

# Create an item and userItem instance (the method should know which item object to sell)
item = Item()
userItem = UserItem(item)

# check arguments
if len(sys.argv) != 4:
    print("Usage: python main.py <sellerID> <itemID> <storeID>")
    sys.exit(1)

sellerID = sys.argv[1]
itemID = sys.argv[2]
storeID = sys.argv[3]

# Call the method sellItemToStore with parameters defined
userItem.sellItemToStore(sellerID, itemID, storeID)
