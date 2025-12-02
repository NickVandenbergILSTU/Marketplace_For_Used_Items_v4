import sys
import os
import json
from pathlib import Path


def verify_security_response(username, security_question, security_answer):
    python_script = Path(__file__).resolve()
    script_directory = python_script.parent
    ACCOUNT_PATH = script_directory.parent.parent /'json'/'accounts.json'
    #read from file
    with open(ACCOUNT_PATH, 'r') as accounts_file:
        local_accounts = json.load(accounts_file)

    selected_account = None
    for account in local_accounts:
        if username in account['username']:
            selected_account = account
            break

    
    if security_question in selected_account['securityQuestion']:
        if security_answer in selected_account['securityAnswer']:
            response = {
                "result": "Success"
            }
            # response_json = json.dumps(response)
            
            return response
        else:
            response = {
                "result": "Failure"
            }
            response_json = json.dumps(response)
            print(response_json)
            sys.stdout.flush()
            return

username = sys.argv[1]
security_question = sys.argv[2]
security_answer= sys.argv[3]


try:

    response = verify_security_response(username, security_question, security_answer)
    response_json = json.dumps(response)
    print(response_json)
    sys.stdout.flush()
    sys.exit(0)

except Exception as e:
    print(e)
    sys.exit(1)
