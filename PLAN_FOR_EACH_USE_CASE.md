NOTES:
- textboxes displayed in html containing bash script paths should be immutable, unless the script being run takes parameters, in which case the textbox should be mutable
    - (mutable means the user can change the text on the front end, immutable is the opposite)

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
- Each box contains the text box with the script path to run to accomplish each task
    - For now, put placeholder text in that box, since the scripts haven't been made yet
- Each box should have instructions like "Copy and paste this into your terminal to Create Account/Login", as well as explain what parameters to pass in
    - Login will have first name, last name, email, and password as parameters
    - Create account will have each of the parameters login has, AND:
        - security question
        - security answer
- Each text box should be decently big, since we don't have that much on the screen, and there are params the user must enter

===================================================================

3. Main menu html page:
- From here, the 


When items are being displayed in a list of marketplace items, and in a list of a user's items, 