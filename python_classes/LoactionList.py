import subprocess
import os

class Location_List:
    def __init__(self):
        pass

    def addLocation(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'add_location', 'add_location.sh')
        )
        subprocess.run(['bash', script_path], check=True)
    
    