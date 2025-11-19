WELCOME TO THE MARKETPLACE FOR USED ITEMS!

IF YOU HAVEN'T SET EVERYTHING UP YET, SEE /START_HERE.md

TO OPEN THE MARKETPLACE, RUN THIS COMMAND IN A VSCODE BASH TERMINAL, AND FOLLOW THE LOCALHOST LINK:

./start.sh

Our project is can be broken down into a four-tier system:

<h3>Tier 1 - Presentation Layer</h3>
Our presentation layer is the visual aspect to our project. It handles the HTML/CSS/Javascript that helps run our website. Things such as the visualization of items, stores, rating items and leaving comments, all happen here.

<h3>Tier 2 - Application Layer</h3>
The application layers is the in-between that helps facilitate communication from our Presentation layer to the Domain layer. At the moment, we have all communication happening through our facade controller, /run-script. This helps direct the data to the proper channel.

<h3>Tier 3 - Data Access</h3>
This is the back-end of our system, which runs the specified script to handle the operation being requested. Things such as creating/deleting a user, creating an item, checking out your shopping cart, all happen behind the scenes here.

<h3>Tier 4 - Database</h3>
This is where our JSON files live, which allow us to have persistant data throughout our projects. This is broken up into items, accounts, locations, and our local_data.

<img width="430" height="605" alt="image" src="https://github.com/user-attachments/assets/b75db024-738d-47bb-94ff-56e0e7b1b350" />


<h1>COMMUNICATION</h1>

Currently, our UI communicates with the application layer by invoking our Facade Controller. This then directs traffic to the script responsible for handling the request. For example, when we delete an account, we will make a request to our Facade Controller. It will then direct the request to the deleteAccount.sh, which communicates with our UserDataAccess to remove the user from out accounts.json.
