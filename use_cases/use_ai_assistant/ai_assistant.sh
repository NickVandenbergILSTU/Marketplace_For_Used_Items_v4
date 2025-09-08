#!/bin/bash

JSON_DIR="json/other_json"

if [ "$(jq -r '.hasUsedAIAssistant' $JSON_DIR/local_data.json)" = false ]; then
  jq '.hasUsedAIAssistant = true' $JSON_DIR/local_data.json > $JSON_DIR/tmp.json && mv $JSON_DIR/tmp.json $JSON_DIR/local_data.json
  pip install openai
  pip install python-dotenv
fi

python ./use_cases/use_ai_assistant/main.py