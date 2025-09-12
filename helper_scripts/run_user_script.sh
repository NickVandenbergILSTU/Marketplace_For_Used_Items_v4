#!/bin/bash

# have this script run from the js file

# Notes:
# - git push and pull are slow, each take like 5 seconds
# - First param is the path of the script to run, subsequent params are parameters to that script

# =============================================
# START SCRIPT HERE:

script_path=$1

# UNCOMMENT FOR PULLING AND PUSHING: If the script involves reading OR writing user data (json, user images, user ai convo history, etc.) > git pull
# if($script_path = insert scripts that read or write user data (i.e. json) here)
# then
  git pull
# fi

# runs script stored in script_path variable, with all parameters
$script_path "${@:2}"

# UNCOMMENT FOR PULLING AND PUSHING: f script involves writing user data > git add files; git commit -m "message"; git push {files that could have been changed}
# if($script_path = insert scripts that write user data (i.e. json) here)
# then
  git add . # {add other data to push here}
  git commit -m "[AUTOMATED COMMIT, DATA UPDATED]"
  git push
# fi

