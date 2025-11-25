import json
from pathlib import Path
python_script = Path(__file__).resolve()
script_directory = python_script.parent
ACCOUNT_PATH = script_directory.parent / 'json'/'accounts.json'
print(ACCOUNT_PATH)
#ACCOUNT_PATH = script_directory.parent / 'accounts.json'

class UserRepo:
    def __init__(self):
        self.file_path = ACCOUNT_PATH
        self._local_accounts = None

        with open(self.file_path, 'r') as file:
            self._local_accounts = json.load(file)

        self._UserArray = []

    def get_user_by_id(self, id):
        #Check if local accounts is already loaded
        # if self._local_accounts is None:
        #     self._local_accounts = self.load_accounts_file()
        
        for account in self._local_accounts:
            if account['id'] == id:
                return account
    