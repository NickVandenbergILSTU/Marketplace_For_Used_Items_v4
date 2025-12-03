import sys
import os

# Add python_classes folder to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from item import Item


if len(sys.argv) != 3:
    print("Usage: python main.py <item_id> <comment>")
    sys.exit(1)

item_id = int(sys.argv[1])
comment = sys.argv[2]

# Create an Item instance and add comment
item = Item()
item.itemID = item_id
item.addComment(comment)