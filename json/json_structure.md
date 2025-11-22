NOTE:
every group member must create
- accounts.json, 
- items.json, 
- and locations.json in their json/ folder in vscode.

THERE WILL BE A TXT FILE IN THIS FOLDER FOR EACH JSON FILE (i.e. items.txt)
COPY CONTENTS OF items.txt into a new folder items.json in your remote repo


====================================
accounts.json:

Array of accounts containing:
- account id (randomly generated 20 digit number)
- username (must be unique)
- email (must be unique)
- password
- account balance
- order history (array of item ids)
- bookmarked items (array of item ids)
- security question string (for forgot password)
- security answer string (for forgot password)
- shopping cart (array of item ids)
- profile picture png path (optional)
- array of items this account owns (the array will just store item ids)
- default store (location id)
- array of store ids (stores owned by each user)
- auto push and pull data boolean

=====================================================================
items.json:

keep a json file for each item that exists (each item that belongs to someone or a store):

    - item name (must be unique)
    - item id (randomly generated 20 digit number)
    - comments array (store id of person who posted the comment, and comment itself)
    - isReserved boolean (change this to false once the item is purchased)
    - string: picture path (picture is optional, set to "null" if no picture)
    - price
    - ratings array (stores account id, and what rating they gave)
    - hasImage boolean?

once an item is added, it will not be deleted from this array

=======================================================
locations.json:

Array of stores. Each store has:
- store id (randomly generated 20 digit number)
- store name
- store address
- array of item ids (these are the ids of the items in this store, use id because they are immutable)

=================================

local_data.json:
- hasUsedAIAssistant: false by default
- currentlyLoggedInUserID: -1 by default (-1 means no one logged in)

==========================================
security_questions.json:

An array of security questions. Each account with have to choose answers to 2.