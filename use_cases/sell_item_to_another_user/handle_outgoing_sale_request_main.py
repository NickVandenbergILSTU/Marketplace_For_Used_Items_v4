import sys
import os

# Add python_classes folder to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from seller import Seller


if len(sys.argv) != 3:
    print("Usage: python main.py <item_id> <target_user_id>")
    sys.exit(1)

item_id = sys.argv[1]
target_user_id = sys.argv[2]

# Create a Seller instance and handle outgoing sale request
seller = Seller()
seller.handleOutgoingSaleRequest(item_id, target_user_id)