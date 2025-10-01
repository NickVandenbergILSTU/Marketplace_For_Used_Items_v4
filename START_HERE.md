SETTING UP:

1. MAKE SURE YOUR PC HAS THE FOLLOWING DOWNLOADED:

    - Git Bash
    - Python
    - JQ
        - For Windows:
            - Go to https://jqlang.org/
            - Rename the file you download to jq
            - Put jq somewhere on your C drive
            - Open up "Edit the system and environment variables" > "Environment Variables" > add the folder jq is in to your system and user variables, click ok to save
            - To test this worked, open CMD and type "jq --version"
    - JavaScript
        - Go to https://nodejs.org
        - Download the LTS (Long Term Support) version (stable).
        - Run the installer > it will install Node.js and npm (Node Package Manager).
        - To verify installation, open a terminal and run:
            node -v
            npm -v
        - Then:
            npm init -y
            npm install express
            make sure your bash script is executable doing:
                chmod +x ./{path_to_script}
        - Then start javascript doing:
            node {path to javascript file}
        - Check LABS project > Nick's test repo > feature/javascript branch

2. MAKE SURE YOU HAVE THE REPO CLONED INTO VSCODE

3. CHANGE THE DIRECTORY TO THE ROOT OF YOUR REPO

4. THERE IS DATA THAT ONLY WILL EXIST IN YOUR LOCAL REPO, NOT IN AZURE DEVOPS/GITHUB. 
RUN THIS SCRIPT TO SET THOSE FILES UP:
./helper_scripts/set_default_local_data_and_installs/set_default_local_data.sh

5. TO BE ABLE TO COMMIT CHANGES:
git config --global user.name "{username}"
git config --global user.email "{email}"
git remote set-url origin https://{github_pat}@github.com/NickVandenbergILSTU/Marketplace_For_Used_Items_v4.git

6. IF YOU HAVE ISSUES WITH INSTALLS, RUN THIS:
./helper_scripts/set_default_local_data_and_installs/run_installs.sh