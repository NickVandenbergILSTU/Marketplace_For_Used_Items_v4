import subprocess
import os
from user.py import User

class Buyer(User):
    def __init__(self):
        pass

    def handleIncomingSaleRequest(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'handle_incoming_sale_request', 'handle_incoming_sale_request.sh')
        )
        subprocess.run(['bash', script_path], check=True)
    