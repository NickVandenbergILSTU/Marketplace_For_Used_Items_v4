#!/bin/bash

# Check whether this script has 2 parameters, print an error message
# and exit if not

# check whether password and username passed in match an account in accounts.json
# if so, set loggedInUserID in local_data.json to that user's id, print success message
# if not, print error message and exit

# Check whether this script has 2 parameters, print an error message and exit if not

USERNAME="$1"
PASSWORD="$2"
ACCOUNTS_JSON_PATH="json/accounts.json"
LOCAL_DATA_JSON_PATH="json/local/local_data.json"

# echo $USERNAME
echo $PASSWORD

# if [ "$#" -ne 2 or]; then
#     echo "Error: Please provide both username and password."
#     exit 1
# fi

if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
  echo "Error: Both USERNAME and PASSWORD parameters are required."
  exit 1
fi

# Check whether username and password match an account in accounts.json
USER_ID=$(jq -r --arg u "$USERNAME" --arg p "$PASSWORD" \
    '.[] | select(.username==$u and .password==$p) | .id' $ACCOUNTS_JSON_PATH)

# If no id field exists in accounts.json yet, fall back to using the index as ID
if [ -z "$USER_ID" ] || [ "$USER_ID" == "null" ]; then
    USER_ID=$(jq -r --arg u "$USERNAME" --arg p "$PASSWORD" \
        'to_entries[] | select(.value.username==$u and .value.password==$p) | .key' $ACCOUNTS_JSON_PATH)
fi

if [ -n "$USER_ID" ]; then
    # Set loggedInUserID in local_data.json
    jq --argjson id "$USER_ID" '.currentlyLoggedInUserID = $id' $LOCAL_DATA_JSON_PATH > tmp.$$.json && mv tmp.$$.json $LOCAL_DATA_JSON_PATH
    echo "Login successful."
else
    echo "Error: Invalid username or password."
    exit 1
fi
