import os
import sys
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from user import User

current_user = User()
username = sys.argv[1]
password = sys.argv[2]
#print(username, password)
current_user.change_password(username, password)
