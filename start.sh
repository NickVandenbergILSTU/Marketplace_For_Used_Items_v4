#!/bin/bash

ACCOUNTS_PATH="json/accounts.json"

# If any account is logged in, open main menu, otherwise, go to login page
if jq -e '.[] | select(.loggedIn == true)' "$ACCOUNTS_PATH" > /dev/null; then
    ./helper_scripts/start_html_multi_platform.sh "html/main_menu.html"
else
    ./helper_scripts/start_html_multi_platform.sh "html/login.html"
fi
