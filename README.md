WELCOME TO THE MARKETPLACE FOR USED ITEMS!

IF YOU HAVEN'T SET EVERYTHING UP YET, SEE /START_HERE.md

TO OPEN THE MARKETPLACE, RUN THIS COMMAND IN A VSCODE BASH TERMINAL, AND FOLLOW THE LOCALHOST LINK:

./start.sh

Our project is can be broken down into a four-tier system:

Tier 1 - Presentation Layer
Our presentation layer is the visual aspect to our project. It handles the HTML/CSS/Javascript that helps run our website. Things such as the visualization of items, stores, rating items and leaving comments, all happen here.

Tier 2 - Application Layer
The application layers is the in-between that helps facilitate communication from our Presentation layer to the Domain layer. At the moment, we have all communication happening through our facade controller, /run-script. This helps direct the data to the proper channel.

Tier 3 - Domain Layer
This is the back-end of our system, which runs the specified script to handle the operation being requested. Things such as creating/deleting a user, creating an item, checking out your shopping cart, all happen behind the scenes here.

Tier 4 - Data Layer
This is where our JSON files live, which allow us to have persistant data throughout our projects. This is broken up into items, accounts, locations, and our local_data.

<img width="451" height="607" alt="image" src="https://github.com/user-attachments/assets/890ff523-757e-4f3e-9750-3bae0602c88f" />

