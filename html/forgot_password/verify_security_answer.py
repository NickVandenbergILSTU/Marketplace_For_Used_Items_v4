import json
import sys


def verify_security_answer(entered_username, sq_question_id, sq_answer):
    # somehow pull the username

    result_response = {
        "response": "Security question ID or answer is incorrect",
        "status": "fail"
    }

    selected_account = None
    #account_id = None
    with open('../../json/accounts.json','r') as accounts:
        data = json.load(accounts)
        for user in data:
            if user.get("username") == entered_username:
                #account_id = user.get("id")
                selected_account = user
                break

    #print(f'Selected account:\n {selected_account} \n ')
        
    questions = selected_account["security_q_a"]

    #print(type(questions))
    correct_key_answer = False
    for key, answer in questions.items():
        if key == sq_question_id:
            if answer == sq_answer:
                # if everything is correct
                correct_key_answer = True
                
        
    
    if (correct_key_answer) == False:
        response_json = json.dumps(result_response)
        print(response_json)
        sys.stdout.flush()
    else:
        response = {
                    "result" : "Success"
                }
        response_json = json.dumps(response)
        print(response_json)
        sys.stdout.flush()
        
            
    
    #print(selected_account.get("security_q_a"))



    
username_to_check = sys.argv[1]
sq_question_id = sys.argv[2]
sq_answer = sys.argv[3]


verify_security_answer(username_to_check, sq_question_id, sq_answer)


# if __name__ == "__main__":
#     # sys.argv[0] is the script name itself, sys.argv[1] is the first argument (the username)
#     if len(sys.argv) > 1:
#         entered_username = sys.argv[1]
#         get_user_exist(entered_username)