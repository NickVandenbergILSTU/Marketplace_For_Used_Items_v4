import sys
import os

# Add python_classes folder to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from buyer import Buyer


if len(sys.argv) != 3:
    print("Usage: python main.py <accept|reject> <item_id>")
    sys.exit(1)

action = sys.argv[1]
item_id = sys.argv[2]

# Create a Buyer instance and handle incoming sale request
buyer = Buyer()
buyer.handleIncomingSaleRequest(action, item_id)