import sys
import os

# Add python_classes folder to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from itemListing import Item_Listing


if len(sys.argv) != 3:
    print("Usage: python main.py <reserve|unreserve> <item_id>")
    sys.exit(1)

action = sys.argv[1]
item_id = int(sys.argv[2])

item_listing = Item_Listing()

if action == "reserve":
    item_listing.reserveItem(item_id)
elif action == "unreserve":
    item_listing.unreserveItem(item_id)
else:
    print("Error: Action must be 'reserve' or 'unreserve'")
    sys.exit(1)