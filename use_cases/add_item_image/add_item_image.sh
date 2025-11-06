#!/bin/bash

TARGET_DIR="images/items"
item_id="$1"

# If _ITEM_IMAGE_DROPBOX does not have exactly 1 file inside, exit with error
if [ "$(ls -A "_ITEM_IMAGE_DROPBOX" | wc -l)" -ne 1 ]; then
  echo "Error: Expected exactly one file in _ITEM_IMAGE_DROPBOX"
  exit 1
fi

# if the item inside _ITEM_IMAGE_DROPBOX is not a png file, exit with error
if [[ ! "$(ls "_ITEM_IMAGE_DROPBOX")" =~ \.png$ ]]; then
  echo "Error: The file in _ITEM_IMAGE_DROPBOX is not a PNG file"
  exit 1
fi

# Move the single file from _ITEM_IMAGE_DROPBOX to target directory with the name (item_id).png
mv "_ITEM_IMAGE_DROPBOX"/*.png "$TARGET_DIR/$item_id.png"