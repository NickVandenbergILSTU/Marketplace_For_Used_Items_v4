import json
import sys
from pathlib import Path


def verify_security_answer(entered_username, sq_question_id, sq_answer):

    python_script = Path(__file__).resolve()
    script_directory = python_script.parent
    accounts_path = script_directory.parent.parent /'json'/'accounts.json'
    
    selected_account = None
    with open(accounts_path,'r') as accounts:
        data = json.load(accounts)
        for user in data:
            if user.get("username") == entered_username:
                #account_id = user.get("id")
                selected_account = user
                break

    if selected_account is None:
        response_json = json.dumps({
            "result": "Failure",
            "type": "Bad",
            "error": "Username not found"
        })
        print(response_json)
        sys.stdout.flush()
        return
    

    questions = selected_account["security_q_a"]

    correct_key_answer = False
    for key, answer in questions.items():
        if key == sq_question_id:
            if answer == sq_answer:
                # if everything is correct
                correct_key_answer = True
                break
            
                
    result_response = {
        "result" : "Failure",
        "type" : "Bad"
    }
    
    if (correct_key_answer) == False:
        response_json = json.dumps(result_response)
        print(response_json)
        sys.stdout.flush()
    else:
        response = {
                    "result" : "Success",
                    "test" : entered_username
                }
        response_json = json.dumps(response)
        print(response_json)
        sys.stdout.flush()
        

if __name__ == "__main__":
    if len(sys.argv) < 3:
        sys.exit(1)

    entered_username = sys.argv[1]
    sq_question_id = sys.argv[2]
    sq_answer = sys.argv[3]

    verify_security_answer(entered_username, sq_question_id, sq_answer)