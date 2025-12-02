#!/bin/bash

# RUN THIS SCRIPT FOR ALL USE CASES

# Notes:
# - git push and pull are slow, each take like 5 seconds
# - First param is the path of the script to run, subsequent params are parameters to that script
# - If script involves reading or writing user data (json, user images, user ai convo history, etc.), look below for where to add it (either READ_ONLY_LIST or READ_AND_WRITE_LIST)

SCRIPT_PATH=$1
LOCAL_DATA_PATH="json/local/local_data.json"
ACCOUNTS_JSON_PATH="json/accounts.json"
CURRENTLY_LOGGED_IN_USER_ID=$(jq -r '.currentlyLoggedInUserID' "$LOCAL_DATA_PATH")

# ==================================================================
# ERROR HANDLING:
# ==================================================================

# # if local_data.json currentlyLoggedInUserID is -1, exit script and throw error
# if [ "$(jq -r '.currentlyLoggedInUserID' "$LOCAL_DATA_PATH")" == "-1" ] && \
#    [ "$SCRIPT_PATH" != "./use_cases/login_and_create_account/login.sh" ] && \
#    [ "$SCRIPT_PATH" != "./use_cases/login_and_create_account/create_acct.sh" ]; then
#   echo "Error: No user is currently logged in. Please log out and log in in to continue."
#   #question that it should be error if nobody logged in is -1
#   exit 1
# fi

if [ -z "$SCRIPT_PATH" ]; then
  echo "Error: No script path provided."
  exit 1
fi

# ==================================================================
# CHECKING WHAT SCRIPTS TO PULL AND PUSH DATA FOR:
# ==================================================================

# The value of the string autoPushAndPullData in ACCOUNS_JSON_PATH:
auto_push_and_pull_data=$(jq -r --argjson id "$CURRENTLY_LOGGED_IN_USER_ID" '.[] | select(.id==$id) | .autoPushAndPullData' "$ACCOUNTS_JSON_PATH")



# Following commented out 12/1/25
# # Add scripts that READ DATA ONLY here
# # ...don't add scripts that write data here
# # DON'T include scrips that read data that only exists locally, pulls are not necessry then
# if [ "$auto_push_and_pull_data" == "true" ] && \
#    { [ "$SCRIPT_PATH" == "./use_cases/login_and_create_account/login.sh" ]; \
#    }; then
#   read_only="true"
# else
#   read_only="false"
# fi

# # Add scripts that READ AND WRITE data to files that EXIST IN REMOTE REPO here:
# if [ "$auto_push_and_pull_data" == "true" ] && \
#    { [ "$SCRIPT_PATH" == "./use_cases/login_and_create_account/create_account.sh" ]; \
#    }; then
#   read_and_write="true"
# else
#   read_and_write="false"
# fi

# New logic 12/1/25
if [ "$auto_push_and_pull_data" == "true" ]; then
  read_only="true"
  read_and_write="true"
  echo "Auto Push and Pull Data - enabled"
else
  read_only="false"
  read_and_write="false"
  echo "Auto Push and Pull Data - disabled"
fi

# ==================================================================
# PULL, RUN, PUSH:
# ==================================================================

# If the script involves reading OR writing user data (json, user images, user ai convo history, etc.) > git pull
if [ "$read_only" == "true" ] || [ "$read_and_write" == "true" ]; then
  git pull
  echo "Data pulled from remote repository."
fi

# Run script
ext="${SCRIPT_PATH: -3}"

if [ "$ext" = ".sh" ]; then
    "$SCRIPT_PATH" "${@:2}"
elif [ "$ext" = ".py" ]; then
    python "$SCRIPT_PATH" "${@:2}"
else
    echo "Error: Unsupported file type. Only .sh and .py are allowed."
    exit 1
fi

# If script involves writing user data > git add files; git commit -m "message"; git push {files that could have been changed}
if [ "$read_and_write" == "true" ]; then
  git add json/*.json images/*/*.png
  git commit -m "[AUTOMATED COMMIT, DATA UPDATED]"
  git push
  echo "Data pushed to remote repository."
fi
