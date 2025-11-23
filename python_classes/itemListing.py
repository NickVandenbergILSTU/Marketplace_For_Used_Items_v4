import subprocess
import os
from Item import Item

class Item_Listing(Item):
    def __init__(self):
        pass
    
    def reserveItem(sel, itemID):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'reserve_item', 'reserve_item.sh')
        )
        subprocess.run(['bash', script_path, str(itemID)], check=True)
    
    def unreserveItem(self, itemID):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'unreserve_item', 'unreserve_item.sh')
        )
        subprocess.run(['bash', script_path, str(itemID)], check=True)
    
    def addToShoppingCart(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'add_to_shopping_cart', 'add_to_shopping_cart.sh')
        )
        subprocess.run(['bash', script_path], check=True)
    
    