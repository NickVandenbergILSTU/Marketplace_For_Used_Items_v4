#!/bin/bash

# add mkdirs
mkdir -p json/local
mkdir -p use_cases/use_ai_assistant

# include: local_data.json, .env in ai assistant, anything else in gitignore
cp helper_scripts/set_default_local_data_and_installs/local_data.json json/local

# Removing ai assistant:
# cp helper_scripts/set_default_local_data_and_installs/.env use_cases/use_ai_assistant