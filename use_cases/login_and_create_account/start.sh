#!/bin/bash

# Comments:
# - USER SCRIPT

# Path to accounts.json
ACCOUNTS_PATH="json/accounts.json"

./helper_scripts/start_multi_platform.sh "use_cases/login_and_create_account/login.html"

# Check if any account has loggedIn = true
if jq -e '.[] | select(.loggedIn == true)' "$ACCOUNTS_PATH" > /dev/null; then
    echo "At least one account is logged in. Not starting multi-platform."
else
    echo "No accounts logged in. Starting multi-platform..."
    ./helper_scripts/start_html_multi_platform.sh "use_cases/login_and_create_account/login.html"
fi
