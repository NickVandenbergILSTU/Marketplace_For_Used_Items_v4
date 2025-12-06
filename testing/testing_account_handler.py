import pytest
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
     

@mock.patch('subpress.run')
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
