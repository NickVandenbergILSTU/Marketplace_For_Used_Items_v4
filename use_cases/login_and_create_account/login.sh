#!/bin/bash

# Check whether this script was called with the right num of parameters, print an error message
# and exit if not

# check whether password and email/username passed in match an account in accounts.json
# if so, set loggedInUserID in local_data.json to that user's id, print success message, and open the main menu (use the helper script called in start.sh)
# if not, print error message and exit

echo "Username: $1. Password: $2"