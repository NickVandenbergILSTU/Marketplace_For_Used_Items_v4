import subprocess
import os
from user import User

class Buyer(User):
    def __init__(self):
        self.buyerItem = None

    def handleIncomingSaleRequest(self, action, itemID):
    # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'sell_item_to_another_user', 'handle_incoming_sale_request.sh')
        )
        subprocess.run(['bash', script_path, action, str(itemID)], check=True)
    
