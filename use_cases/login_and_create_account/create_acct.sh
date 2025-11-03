#!/bin/bash


# redirect user to main menu when script is done

file="./json/accounts.json"

username="$1"
password="$2"
password2="$3"
email="$4"
securityQuestion="$5"
securityAnswer="$6"

#username input and checks if taken
exists=$(jq --arg u "$username" '[.[] | select(.username == $u)] | length' "$file")
if [ "$exists" -gt 0 ]; then
  echo "Username '$username' is already taken."
  exit 1
fi

#email input and checks if taken and checks it is valid with @ and .
exists=$(jq --arg e "$email" '[.[] | select(.email == $e)] | length' "$file")
if [ "$exists" -gt 0 ]; then
  echo "Email '$email' is already taken."
  exit 1
fi

if [[ ! "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
  echo "Invalid email format. Please enter a valid email address."
  exit 1
fi

#password input and checks requirements (should have user reenter to confirm password)
./use_cases/check_password_requirements/check_password_requirements.sh "$password"
if [ $? -ne 0 ]; then
    echo "Password does not meet requirements. Please try again."
    exit 1
fi


#check password confirmation
if [ "$password" != "$password2" ]; then
    echo "Passwords do not match. Please try again."
    exit 1
fi



#security question id to question
case $securityQuestion in
    ("1")
        securityQuestion="What is the name of your first pet?"
        ;;
    ("2")
        securityQuestion="What university did you study at?"
        ;;
    ("3")
        securityQuestion="What was the name of your elementary school?"
        ;;
    (*)
        echo "Invalid security question selected."
        exit 1
        ;;
esac

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

local_data="./json/local/local_data.json"




# Log in new user (only if creation succeeded)
    jq --argjson id "$new_id" '.currentlyLoggedInUserID = $id' "$local_data" > tmp.$$.json && mv tmp.$$.json "$local_data"

echo "✅ User '$username' is now logged in."

# --- REDIRECT TO MAIN MENU (only if creation succeeded) ---
xdg-open "./html/main_menu.html" >/dev/null 2>&1 &
exit 0