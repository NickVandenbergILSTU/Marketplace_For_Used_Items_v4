import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from userItem import UserItem

# Create a UserItem instance and delete Item
Item = userItem()
item_id = int(sys.argv[1])

Item.id = item_id
Item.deleteItem()