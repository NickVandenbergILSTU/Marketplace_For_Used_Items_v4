import subprocess
import os

class Item:
    def __init__(self):
        pass

    def create_item(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'create_item', 'create_item.sh')
        )
        subprocess.run(['bash', script_path], check=True)