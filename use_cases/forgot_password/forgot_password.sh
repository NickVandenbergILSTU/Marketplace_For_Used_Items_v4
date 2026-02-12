#!/bin/bash

# if the script has the wrong number of parameters, or if any param is empty, print an error message and exit

# open an html file with the security question printed to the screen
# the file also takes in the following as params:
# - security answer
# - new password

# if the security answer is correct, check for the password

# check password using the script ./use_cases/check_password_requirements/check_password_requirements.sh
# if the password meets requirements:
# - update the password stored in the json,
# - set loggedin variable in local_data.json,
# - redirect to main menu
# if not:
# - print an error message saying the security answer was correct, put password doesn't meet requirements, exit 1

