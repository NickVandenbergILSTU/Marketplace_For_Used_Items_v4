#!/bin/bash

message="${1:-[AUTOMATED COMMIT, DATA UPDATED]}"
git add .
git commit -m "$message"
git push