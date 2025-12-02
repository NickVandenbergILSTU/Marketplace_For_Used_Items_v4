import subprocess
import os

class User:
    def __init__(self):
        self.id = None
        self.userName= None
        self.password = None
        self.email = None
        self.securityQuestion = None
        self.securityAnswer = None
        self.autoPushAndPullData = False
        self.accountBalance = 0.0
        self.incomingSaleRequests = []
        self.outgoingSaleRequests = []
        self.bookmarkedItemIds = []
        self.itemsInCartIds = []
        self.orderHistoryIds = []

    def createNewItem(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'create_item', 'create_item.sh')
        )
        subprocess.run(['bash', script_path], check=True)

    def change_password(self, username, password):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'forgot_password','change_password.py')
        )
        subprocess.run(['python', script_path, username, password], check=True)
        return self