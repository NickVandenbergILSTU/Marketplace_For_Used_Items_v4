import subprocess
import os
from user import User

class Seller(User):
    def __init__(self):
        self.sellerItem = None

    def handleOutgoingSaleRequest(self, itemID, targetUserID):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'sell_item_to_another_user', 'handle_outgoing_sale_request.sh')
        )
        subprocess.run(['bash', script_path, str(itemID), str(targetUserID)], check=True)

    def sellItemToAnotherUser(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'sell_item_to_another_user', 'sell_item_to_another_user.sh')
        )
        subprocess.run(['bash', script_path], check=True)
