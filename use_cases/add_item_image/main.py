import sys
import os

# Add python_classes folder to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from userItem import UserItem


if len(sys.argv) != 2:
    print("Usage: python main.py <item_id>")
    print("Note: Place a single PNG file in _ITEM_IMAGE_DROPBOX folder first")
    sys.exit(1)

item_id = int(sys.argv[1])

# Create a UserItem instance and post picture
user_item = UserItem()
user_item.postItemPicture(item_id)