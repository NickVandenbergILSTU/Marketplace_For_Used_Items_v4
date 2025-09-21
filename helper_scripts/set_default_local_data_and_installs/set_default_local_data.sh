#!/bin/bash

# include: local_data.json, .env in ai assistant, anything else in gitignore
cp helper_scripts/set_default_local_data_and_installs/local_data.json json/local
cp helper_scripts/set_default_local_data_and_installs/.env use_cases/use_ai_assistant