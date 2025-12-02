push_data.sh: pushes imgs and json other than regex in gitignore

  git add json/*.json images/*/*.png
  git commit -m "[AUTOMATED COMMIT, DATA UPDATED]"
  git push
  echo "Data pushed to remote repository."