# exit if the password doesn't meet requirements

#!/bin/bash

# check_password_requirements.sh
# Validates that a password meets strength requirements:
# - At least 8 characters
# - At least 1 uppercase letter
# - At least 1 digit

PASSWORD="$1"

# Check if password parameter is provided
if [ -z "$PASSWORD" ]; then
    echo "Error: Password parameter is required."
    exit 1
fi

# Check minimum length (at least 8 characters)
if [ ${#PASSWORD} -lt 8 ]; then
    echo "Error: Password must be at least 8 characters long."
    exit 1
fi

# Check for at least one uppercase letter
if ! [[ "$PASSWORD" =~ [A-Z] ]]; then
    echo "Error: Password must contain at least 1 uppercase letter."
    exit 1
fi

# Check for at least one digit
if ! [[ "$PASSWORD" =~ [0-9] ]]; then
    echo "Error: Password must contain at least 1 digit."
    exit 1
fi

# If all checks pass
echo "Password is strong enough."
exit 0