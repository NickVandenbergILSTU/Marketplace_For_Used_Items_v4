#!/bin/bash
# Check whether this script is being called correctly
# Clear the loggedInUserID in local_data.json
# Print success message

LOCAL_DATA_JSON_PATH="json/local/local_data.json"

# Check if local_data.json exists
if [ ! -f "$LOCAL_DATA_JSON_PATH" ]; then
    echo "Error: local_data.json not found."
    exit 1
fi

# Check if there's a currently logged in user
CURRENT_USER_ID=$(jq -r '.currentlyLoggedInUserID' $LOCAL_DATA_JSON_PATH)

if [ -z "$CURRENT_USER_ID" ] || [ "$CURRENT_USER_ID" == "null" ]; then
    echo "Error: No user is currently logged in."
    exit 1
fi

# Clear the currentlyLoggedInUserID field (set to null)
jq '.currentlyLoggedInUserID = -1' $LOCAL_DATA_JSON_PATH > tmp.$$.json && mv tmp.$$.json $LOCAL_DATA_JSON_PATH

echo "Logout successful."