#!/bin/bash

# Usage: change_username.sh <userId> <newUsername>


accountFile="./json/accounts.json"
userID="$1"
newSecurityQuestion="$2"

case $newSecurityQuestion in
    ("1")
        newSecurityQuestion="What is the name of your first pet?"
        ;;
    ("2")
        newSecurityQuestion="What university did you study at?"
        ;;
    ("3")
        newSecurityQuestion="What was the name of your elementary school?"
        ;;
    (*)
        echo "Invalid security question selected."
        exit 1
        ;;
esac

tmp=$(mktemp)
jq --arg uid "$userID" --arg sq "$newSecurityQuestion" '
  map(if .id == ($uid | tonumber) then .securityQuestion = $sq else . end)
' "$accountFile" > "$tmp" && mv "$tmp" "$accountFile"