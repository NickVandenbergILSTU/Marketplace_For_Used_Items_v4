# the first parameter of this script will be stored in item_id
# the script will search items/images/ for a file named (item_id).png
# if found, it will delete that file

#!/bin/bash
item_id=$1 
TARGET_DIR="images/items"

# check if the file exists
if [ -f "$TARGET_DIR/$item_id.png" ]; then
    rm "$TARGET_DIR/$item_id.png"
    echo "Deleted $TARGET_DIR/$item_id.png"
else
    echo "File $TARGET_DIR/$item_id.png not found"
fi