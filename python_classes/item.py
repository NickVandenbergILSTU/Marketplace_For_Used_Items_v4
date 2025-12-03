import subprocess
import os

class Item:
    def __init__(self):
        self.itemID = None
        self.name = None
        self.price = None
        self.ratings = []
        self.comments = []


    def create_item(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'create_item', 'create_item.sh')
        )
        subprocess.run(['bash', script_path], check=True)

    def bookMarkItem(self, itemID):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'bookmark_and_unbookmark_item', 'bookmark_item.sh')
        )
        subprocess.run(['bash', script_path, itemID], check=True)

    def addRating(self, rating):
        self.ratings.append(rating)
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'rate_item', 'rate_item.sh')
        )
        #subprocess.run(['bash', script_path, str(self.itemID), str(rating)], check=True)
        subprocess.run(['bash', script_path, self.itemID, rating], check=True)

    def addComment(self, comment):
        self.comments.append(comment)
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'add_comment', 'add_comment.sh')
        )
        subprocess.run(['bash', script_path, str(self.itemID), comment], check=True)

    def removeComment(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'remove_comment', 'remove_comment.sh')
        )
        subprocess.run(['bash', script_path], check=True)
    
