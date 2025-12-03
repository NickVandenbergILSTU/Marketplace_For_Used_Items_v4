import subprocess
import os
from item import Item 

class UserItem(Item):
    def __init__(self):
        pass

    def postItemPicture(self, itemID):
    # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'add_item_image', 'add_item_image.sh')
        )
        subprocess.run(['bash', script_path, str(itemID)], check=True)
    
    def deleteItemPicture(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'remove_item_picture', 'remove_item_picture.sh')
        )
        subprocess.run(['bash', script_path], check=True)

    def sellItemToStore(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'sell_item_to_store', 'sell_item_to_store.sh')
        )
        subprocess.run(['bash', script_path], check=True)
