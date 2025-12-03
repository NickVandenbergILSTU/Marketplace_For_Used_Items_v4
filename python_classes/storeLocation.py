import subprocess
import os

class Store_Location:
    def __init__(self):
        self.storeName = None
        self.storeItems = []

    def selectStore(self, storeID):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'set_current_store', 'set_current_store.sh')
        )
        subprocess.run(['bash', script_path, str(storeID)], check=True)
    
