#!/bin/bash

# CHECKS:

# set currentlyLoggedInUserID in local_data.json to that user's id

# redirect user to main menu when script is done

file="./json/accounts.json"

username="$1"
password="$2"
password2="$3"
email="$4"


#username input and checks if taken
exists=$(jq --arg u "$username" '[.[] | select(.username == $u)] | length' "$file")
if [ "$exists" -gt 0 ]; then
  echo "❌ Username '$username' is already taken."
  exit 1
fi

#email input and checks if taken
exists=$(jq --arg e "$email" '[.[] | select(.email == $e)] | length' "$file")
if [ "$exists" -gt 0 ]; then
  echo "❌ Email '$email' is already taken."
  exit 1
fi

#password input and checks requirements (should have user reenter to confirm password)
./use_cases/check_password_requirements/check_password_requirements.sh "$password"
if [ $? -ne 0 ]; then
    echo "❌ Password does not meet requirements. Please try again."
    exit 1
fi




#read -p "Enter security question: " securityQuestion
#read -p "Enter security answer: " securityAnswer

#generate new id
last_id=$(jq '.[-1].id // 0' "$file")
new_id=$((last_id + 1))

#append new account to accounts.json
tmp=$(mktemp)
jq --arg id "$new_id" \
   --arg username "$username" \
   --arg password "$password" \
   --arg email "$email" \
   --arg securityQuestion "$securityQuestion" \
   --arg securityAnswer "$securityAnswer" \
   '. += [{
     id: ($id | tonumber),
     username: $username,
     password: $password,
     email: $email,
     securityQuestion: $securityQuestion,
     securityAnswer: $securityAnswer,
     autoPushAndPullData: "false",
     accountBlanance: 0.00,
     myItems: [],
     bookmarkedItems: [],
     reservedItems: [],
     itemsInCart: [],
     orderHistory: []
   }]' "$file" > "$tmp" && mv "$tmp" "$file"

echo "New account for '$username' created successfully!"