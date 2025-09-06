#/bin/bash

pwd

# If accounts.json doesn't have an element in accounts array with 
# a field "isLoggedIn: set to true, start login html page. Else,
# start main menu
if ! grep -q '"isLoggedIn": true' ./json/accounts.json; then
    start_html_multi_platform.sh ./use_cases/login_and_create_account/login.html
else
    # UNCOMMENT LATER
    # start_html_multi_platform.sh {path for main menu html}
fi