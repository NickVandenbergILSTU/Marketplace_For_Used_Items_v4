Most use cases will strictly consist of writing a Bash Script (or Python),
that executes the tasks for the use case. The forgot password use case will require creating an html file, which Eric is working on. Other than that, it will probably be all Bash or Python.  Writing use case scripts with Bash is highly recommended, though.

Order of operations for each use case:
1. Create a branch that you will plan to use for the whole project
    Title it {your_name}/branch_v1, (i.e. nick's branch is nick/branch_v1)
    Use this branch for each use case, create subsequent branches called {name}/branch_v2 etc. if necessary
2. Check the /use_cases folder for a script for your use case
    If one doesn't already exist, create a .sh file for bash or .py file for python, and put 
3. Write your script (and html for forgot password)










































==============================================================================
IGNORE EVERYTHING BELOW THIS LINE
==============================================================================


NOTES FOR EACH USE CASE:
- textboxes displayed in html containing user scripts should be mutable
    - (mutable means the user can change the text on the front end, immutable is the opposite)
- for simplicity sake, we will not have any input interaction in the html files
    - In other words, there won't be any button clicking, scrollers, etc. in html
    - All tasks will be done by copying a path to a script into the VSCode terminal, and a new html file will pop up automatically
    - We will call these scripts that are copied from html **user scripts**
- All the user scripts executed once logged in will have a boolean check at the top to verify whether the user is still logged In
    - They will all look like this:
        - if json shows no user is logged in > echo "You are not logged in, to log in enter this script: {path to start.sh}"
        - This should be echoed into the VSCode terminal

===================================================================

NOTES FOR WHAT TO ADD AFTER USE CASES ALL WORK:
- add some stuff to make it so that clicking a button in html triggers user scripts
    - maybe use json
- add ai marketplace assistant using chat api?
- add automated email of receipt?

==================================================================

1. An html file for login/create account page (combine both):
- The initial script used to open the marketplace will be called start.sh
- In that script, the html file for login/create account will open if:
    - accounts.json shows that the loggedIn boolean is false for each account OR there are no accounts in the json
- otherwise, someone is already logged in, so:
    - start.sh would open up the main menu html page
- the login/create account page should display an immutable text box with the path to the script for each of login and create account

FRONT END DISPLAY:
- Box with title saying "Login", and box with title saying "Create Account"
- Each box contains the text box with the user script path to run to accomplish each task
    - For now, put placeholder text in that box, since the user scripts haven't been made yet
- Each box should have instructions like "Copy and paste this into your terminal to Create Account/Login", as well as explain what parameters to pass in
    - Login will have first name, last name, email, and password as parameters
    - Create account will have each of the parameters login has, AND:
        - security question
        - security answer
- In the box for login, there should also be a text box with the user script for forgot password
    - We can make it so that when the forgot password user script runs, the security question prints to the terminal
    and the user has 1 chance to enter the security response (ignore case).
        - If the user has the right response, prompt them to enter a new password in the terminal
        - If the user responds wrong, echo that the user is wrong and exit
- Each text box should be decently big, since we don't have that much on the screen, and there are params the user must enter

===================================================================

2. Log out
- Once the user script for logging out is done, echo a message into the VSCode terminal saying something like
    - "You are now logged out, copy and paste this user script if you want to log back in: {path to start.sh}"

===========================================================

3. Main menu html page:

The following can be selected from main menu:
    - Store Locations:
        On front end, have a note saying (go here to add/remove stores, )

        the store locations page will display all the current stores to the html, and have the following options:
        - add stores
        - remove stores (have store locations display the store ids, and 
        remove stores will take in the id as a parameter and remove it)
        - after any change is made to the json in the store locations page, a new store locations page will open in a new tab
        - open store (takes in store id as a parameter and opens the store page)
        -Shopping Cart

    - Profile Info
    - Open Default Store
    - Log Out
    - Order History (make set balance accessible here)
    - AI Assistant?
    - View other users (option to sell item to other users here)
    - My Items (lists the items the logged in user owns, and displays the sell item option)

==================================================

4. AI Assistant

- have some check for whether the user has run the ai assistant yet
    - can create a json file called "local_data.json" that has a boolean var
    called "hasUsedAIAssistant".
    - script should look like this:
    {
        if(hasUsedAIAssistant = false){
            pip install openai
            pip install python-dotenv
            change hasUsedAIAssistant in json to true
        }
        python main.py (run chat gpt api python file)
    }
    - change main.py to make it so that the query is the training data (put it in a text file) is added to the user's question, and then sent off
