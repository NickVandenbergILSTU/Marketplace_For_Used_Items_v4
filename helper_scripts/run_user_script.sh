# have this script run from the js file

# Notes:
# - git push and pull are slow, each take like 5 seconds
# - First param is the path of the script to run, subsequent params are parameters to that script

# =============================================
# START SCRIPT HERE:

# Security:
# if logged in variable in local_data.json = -1 (no one logged in) > echo "no one logged in", exit 1

# if the script involves reading OR writing user data (json, user images, user ai convo history, etc.) > git pull

# run script from parameter here

# if script involves writing user data > git add files; git commit -m "message"; git push {files that could have been changed}

