import subprocess
import os

class Account_Handler:
    def __init__(self):
        self.accountArray = []

    def createAccount(self, username, password, password2, email, securityQuestion, securityAnswer):
    # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'create_account', 'create_account.sh')
        )
        subprocess.run(['bash', script_path, username, password, password2, email, securityQuestion, securityAnswer], check=True)


    def deleteAccount(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'delete_account', 'delete_account.sh')
        )
        subprocess.run(['bash', script_path], check=True)
    
    def recoverPassword(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'recover_password', 'recover_password.sh')
        )
        subprocess.run(['bash', script_path], check=True)

    def confirmPassword(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'confirm_password', 'confirm_password.sh')
        )
        subprocess.run(['bash', script_path], check=True)

    def authenticateUser(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'authenticate_user', 'authenticate_user.sh')
        )
        subprocess.run(['bash', script_path], check=True)

    def logoutUser(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'logout_user', 'logout_user.sh')
        )
        subprocess.run(['bash', script_path], check=True)
    
    def loginUser(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'login_user', 'login_user.sh')
        )
        subprocess.run(['bash', script_path], check=True)

    def updateUsername(self, userID, newUsername):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'change_username', 'change_username.sh')
        )
        subprocess.run(['bash', script_path, userID, newUsername], check=True)

    def updatePassword(self, userID, newPassword):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'change_password', 'change_password.sh')
        )
        subprocess.run(['bash', script_path, userID, newPassword], check=True)

    def updateEmail(self, userID, newEmail):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'change_email', 'change_email.sh')
        )
        subprocess.run(['bash', script_path, userID, newEmail], check=True)

    def addFunds(self, userID, amount):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'add_funds', 'add_funds.sh')
        )
        subprocess.run(['bash', script_path, userID, amount], check=True)

    def changeSecurityQuestion(self, userID, newSecurityQuestion):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'change_security_question', 'change_security_question.sh')
        )
        subprocess.run(['bash', script_path, userID, newSecurityQuestion], check=True)