#!/bin/bash

$1 = "[AUTOMATED COMMIT, DATA UPDATED]"
git add .
git commit -m "$1"
git push