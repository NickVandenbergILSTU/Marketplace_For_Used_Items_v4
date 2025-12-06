import subprocess
import os
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))
from item import Item

class UserItem(Item):
    def __init__(self):
        UserItem.id = None
        pass

    def postItemPicture(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'add_item_image', 'add_item_image.sh')
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

    def deleteItem(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'delete_item', 'delete_item.sh')
        )
        subprocess.run(['bash', script_path, str(self.id)], check=True)