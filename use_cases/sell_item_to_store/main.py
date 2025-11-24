import sys
import os

# Add python_classes folder to path (go up one level from use_cases/create_item, then into python_classes)
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from userItem import UserItem
from Item import Item

# Create an item and userItem instance (the method should know which item object to sell)
item = Item()
userItem = UserItem(item)

# Call the method sellItemToStore
userItem.sellItemToStore()
