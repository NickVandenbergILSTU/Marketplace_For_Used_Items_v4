import sys
import os

# Add python_classes folder to path (go up one level from use_cases/create_item, then into python_classes)
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from seller import Seller

if len(sys.argv) != 3:
    print("Usage: python main.py <item_id> <user_id>")
    sys.exit(1)

# Create an Item instance
seller = Seller()


item_id = int(sys.argv[1])
user_id = int(sys.argv[2])

# Call the method
seller.sellItemToAnotherUser(item_id, user_id)