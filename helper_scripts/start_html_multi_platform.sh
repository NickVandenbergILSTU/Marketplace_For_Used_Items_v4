# #!/bin/bash

# # Get the HTML file path from the first argument
# html_path="$1" 

# echo "1"

# # Check the operating system
# case "$(uname -s)" in
#     Darwin) # macOS
#         open "$html_path"
#         ;;
#     Linux) # Linux
#         xdg-open "$html_path"
#         ;;
#     CYGWIN*|MINGW32*|MSYS*|MINGW*) # Windows (via Git Bash/Cygwin)
#         start "$html_path"
#         ;;
#     *) # Unknown OS
#         echo "Unsupported operating system."
#         exit 1
#         ;;
# esac