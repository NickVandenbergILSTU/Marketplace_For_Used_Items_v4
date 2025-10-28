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

file="accounts.json"

read -p "Enter a username: " username

# Step 2: Check if it already exists
exists=$(jq --arg u "$username" '[.[] | select(.username == $u)] | length' "$file")

if [ "$exists" -gt 0 ]; then
  echo "❌ Username '$username' is already taken."
  exit 1
fi

read -p "Enter a password: " password
read -p "Enter security question: " securityQuestion
read -p "Enter security answer: " securityAnswer

last_id=$(jq '.[-1].id // 0' "$file")
new_id=$((last_id + 1))

tmp=$(mktemp)
jq --arg id "$new_id" \
   --arg username "$username" \
   --arg password "$password" \
   --argjson balance "$balance" \
   '. += [{
     id: ($id|tonumber),
     username: $username,
     password: $password,
     autoPushAndPullData: "false",
     accountBlanance: 0.00,
     myItems: [],
     bookmarkedItems: [],
     reservedItems: [],
     itemsInCart: [],
     orderHistory: []
   }]' "$file" > "$tmp" && mv "$tmp" "$file"

echo "New user '$username' added successfully!"