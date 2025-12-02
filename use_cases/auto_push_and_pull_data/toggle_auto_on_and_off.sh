#!/bin/bash

# If auto push and pull is on, it toggles off. vice versa.


# File paths
LOCAL_DATA_PATH="json/local/local_data.json"
ACCOUNTS_PATH="json/accounts.json"

# Read currently logged in user ID
CURRENT_USER_ID=$(jq -r '.currentlyLoggedInUserID' "$LOCAL_DATA_PATH")

if [ -z "$CURRENT_USER_ID" ]; then
  echo "Error: Could not read currentlyLoggedInUserID from $LOCAL_DATA_PATH"
  exit 1
fi

echo "Currently logged in user ID: $CURRENT_USER_ID"

# Find the account and get current autoPushAndPullData value
CURRENT_VALUE=$(jq -r --arg id "$CURRENT_USER_ID" '.[] | select(.id == ($id | tonumber)) | .autoPushAndPullData' "$ACCOUNTS_PATH")

if [ -z "$CURRENT_VALUE" ]; then
  echo "Error: Account with ID $CURRENT_USER_ID not found"
  exit 1
fi

echo "Current autoPushAndPullData value: $CURRENT_VALUE"

# Toggle the value
if [ "$CURRENT_VALUE" = "true" ]; then
  NEW_VALUE="false"
else
  NEW_VALUE="true"
fi

# Update the accounts.json file
jq --arg id "$CURRENT_USER_ID" --arg newval "$NEW_VALUE" \
  'map(if .id == ($id | tonumber) then .autoPushAndPullData = $newval else . end)' \
  "$ACCOUNTS_PATH" > "${ACCOUNTS_PATH}.tmp" && mv "${ACCOUNTS_PATH}.tmp" "$ACCOUNTS_PATH"

echo "Updated autoPushAndPullData to: $NEW_VALUE"