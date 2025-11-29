import subprocess
import os
from python_classes.item import Item

class UserItem(Item):
    def __init__(self):
        pass

    def postItemPicture(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'post_item_picture', 'post_item_picture.sh')
        )
        subprocess.run(['bash', script_path], check=True)

    def renameItem(self, itemID, newItemName):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'rename_item', 'rename_item.sh')
        )
        subprocess.run(['bash', script_path, itemID, newItemName], check=True)
    
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