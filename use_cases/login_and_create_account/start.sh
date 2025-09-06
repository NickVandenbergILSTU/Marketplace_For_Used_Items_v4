#!/bin/bash

# Comments:
# - USER SCRIPT

# ============================================================

ACCOUNTS_PATH="json/accounts.json"

# If any account is logged in, open main menu, otherwise, go to login page
if jq -e '.[] | select(.loggedIn == true)' "$ACCOUNTS_PATH" > /dev/null; then
    ./helper_scripts/start_html_multi_platform.sh {enter path for main menu here}
else
    echo "No accounts logged in. Taking you to login page..."
    ./helper_scripts/start_html_multi_platform.sh "use_cases/login_and_create_account/login.html"
fi
