import sys
import os



# Add python_classes folder to path (go up one level from use_cases/create_item, then into python_classes)
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from item import Item

if len(sys.argv) != 3:
    print("Usage: python main.py <item_ID> <rating>")
    sys.exit(1)

# Create an Item instance
item = Item()
item.itemID = int(sys.argv[1])
rating = int(sys.argv[2])


# Call the method
item.addRating(rating)