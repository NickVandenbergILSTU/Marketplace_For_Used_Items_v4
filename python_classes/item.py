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

    def bookMarkItem(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'bookmark_item', 'bookmark_item.sh')
        )
        subprocess.run(['bash', script_path], check=True)

    def addRating(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'add_rating', 'add_rating.sh')
        )
        subprocess.run(['bash', script_path], check=True)

    def addComment(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'add_comment', 'add_comment.sh')
        )
        subprocess.run(['bash', script_path], check=True)

    def removeComment(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'remove_comment', 'remove_comment.sh')
        )
        subprocess.run(['bash', script_path], check=True)
    
    