# make it so that the account handler's method for creating account is called with
# these params:
# itemID="$1"
# newName="$2"

from python_classes.userItem import UserItem
from python_classes.item import Item
import sys

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