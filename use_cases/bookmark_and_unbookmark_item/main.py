import sys
import os



# Add python_classes folder to path (go up one level from use_cases/create_item, then into python_classes)
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from python_classes.item import Item

if len(sys.argv) != 2:
    print("Usage: python main.py <item_ID> ")
    sys.exit(1)

# Create an Item instance
item = Item()
item.itemID = int(sys.argv[1])



# Call the method
item.bookMarkItem()
