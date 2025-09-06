NOTES FOR EACH USE CASE:
- textboxes displayed in html containing bash script paths should be immutable, unless the script being run takes parameters, in which case the textbox should be mutable
    - (mutable means the user can change the text on the front end, immutable is the opposite)
- for simplicity sake, we will not have any input interaction in the html files
    - In other words, there won't be any button clicking, scrollers, etc. in html
    - All tasks will be done by copying a path to a script into the VSCode terminal, and a new html file will pop up automatically
    - We will call these scripts that are copied from html **user scripts**
- All the user scripts executed once logged in will have a boolean check at the top to verify whether the user is still logged In
    - They will all look like this:
        - if json shows no user is logged in > echo "You are not logged in, to log in enter this script: {path to start.sh}"
        - This should be echoed into the VSCode terminal

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

3. Main menu html page:
- From here, the 


When items are being displayed in a list of marketplace items, and in a list of a user's items, 