#!/bin/bash

# CHECKS:

# Check whether this script was called with the right num of parameters, print an error message
# and exit if not

# check whether the email or username are taken
# if so, print error and exit

# use the script ./use_cases/check_password_requirements/check_password_requirements.sh
# to check the password, print error and exit if not

# ACTIONS:

# take the parameters, and add an account to the array in accounts.json
# parameters should be (in any order)
# - password
# - username
# - security question
# - security answer

#  generate account id by taking max and adding 1(if none set to 0)
# initialize all other fields from accounts part of json_structure.md as empty variables
# set currentlyLoggedInUserID in local_data.json to that user's id

# redirect user to main menu when script is done
