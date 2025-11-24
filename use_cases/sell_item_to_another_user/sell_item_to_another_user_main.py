import sys
import os

# Add python_classes folder to path (go up one level from use_cases/create_item, then into python_classes)
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from seller import Seller

# Create an Item instance
seller = Seller()

# Call the method
seller.sellItemToAnotherUser()