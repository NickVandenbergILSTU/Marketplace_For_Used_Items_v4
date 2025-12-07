
import pytest
import subprocess
import os
from unittest import mock


class Account_Handler:
    def __init__(self):
        self.accountArray = []

    def createAccount(self, username, password, password2, email, securityQuestion, securityAnswer):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'create_account', 'create_account.sh')
        )
        subprocess.run(
            ['bash', script_path, username, password, password2, email, securityQuestion, securityAnswer],
            check=True
        )

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




@mock.patch('subprocess.run')
def test_create_account(mock_run):
   
   #build handler
    account_handler = Account_Handler()

    #test input
    username=  "testRunUsername"
    password=  "1234568A"
    password2 = "1234568A"
    email = "testrunemail@email.com"
    question =  "What is the name of your first pet?"
    answer = "Fido"


   #run our method
    account_handler.createAccount(username, password, password2, email, question, answer)

    mock_run.assert_called_once()

    actual_command_list = mock_run.call_args[0][0]


@mock.patch('subprocess.run')
def test_subprocess_error_is_propagated(mock_run):
    """
    Tests that if the external script fails, the exception is passed up.
    """
    handler = Account_Handler()
    
    #Tell the mock to fail when called, simulating a script error.
    mock_run.side_effect = subprocess.CalledProcessError(returncode=1, cmd='test_script')

    # Check that the appropriate exception is raised.
    with pytest.raises(subprocess.CalledProcessError):
        handler.createAccount("u", "p", "p", "e", "q", "a")



@mock.patch('subprocess.run')
def test_delete_account(mock_run):
    account_handler = Account_Handler()
    account_handler.deleteAccount()
    mock_run.assert_called_once()

    actual_command_list = mock_run.call_args[0][0]

@mock.patch('subprocess.run')
def test_delete_account_error_is_propagated(mock_run):
    handler = Account_Handler()
    mock_run.side_effect = subprocess.CalledProcessError(returncode=1, cmd='delete_account')
    with pytest.raises(subprocess.CalledProcessError):
        handler.deleteAccount()

@mock.patch('subprocess.run')
def test_recover_password(mock_run):
    account_handler = Account_Handler()
    account_handler.recoverPassword()
    mock_run.assert_called_once()

    actual_command_list = mock_run.call_args[0][0]

@mock.patch('subprocess.run')
def test_recover_password_error_is_propagated(mock_run):
    handler = Account_Handler()
    mock_run.side_effect = subprocess.CalledProcessError(returncode=1, cmd='recover_password')
    with pytest.raises(subprocess.CalledProcessError):
        handler.recoverPassword()

@mock.patch('subprocess.run')
def test_confirm_password(mock_run):
    account_handler = Account_Handler()
    account_handler.confirmPassword()
    mock_run.assert_called_once()

    actual_command_list = mock_run.call_args[0][0]

@mock.patch('subprocess.run')
def test_confirm_password_error_is_propagated(mock_run):
    handler = Account_Handler()
    mock_run.side_effect = subprocess.CalledProcessError(returncode=1, cmd='confirm_password')
    with pytest.raises(subprocess.CalledProcessError):
        handler.confirmPassword()

@mock.patch('subprocess.run')
def test_authenticate_user(mock_run):
    account_handler = Account_Handler()
    account_handler.authenticateUser()
    mock_run.assert_called_once()

    actual_command_list = mock_run.call_args[0][0]

@mock.patch('subprocess.run')
def test_authenticate_user_error_is_propagated(mock_run):
    handler = Account_Handler()
    mock_run.side_effect = subprocess.CalledProcessError(returncode=1, cmd='authenticate_user')
    with pytest.raises(subprocess.CalledProcessError):
        handler.authenticateUser()
        
@mock.patch('subprocess.run')
def test_logout_user(mock_run):
    account_handler = Account_Handler()
    account_handler.logoutUser()
    mock_run.assert_called_once()

    actual_command_list = mock_run.call_args[0][0]

@mock.patch('subprocess.run')
def test_logout_user_error_is_propagated(mock_run):
    handler = Account_Handler()
    mock_run.side_effect = subprocess.CalledProcessError(returncode=1, cmd='log_out_user')
    with pytest.raises(subprocess.CalledProcessError):
        handler.logoutUser()



##used to test it to make sure all pass
if __name__ == "__main__":
    pytest.main([__file__, "-v"])
