# make it so that the account handler's method for creating account is called with
# these params:
# itemID="$1"
# newName="$2"
import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from userItem import UserItem
from item import Item


# Get command line arguments (expecting 2 arguments after the script name)
if len(sys.argv) != 3:
    print("Usage: python main.py <itemID> <newItemName>")
    sys.exit(1)

itemID = sys.argv[1]
newItemName = sys.argv[2]

# Create an userItem object
userItem = UserItem()

# call the method rename_item
userItem.renameItem(itemID, newItemName)