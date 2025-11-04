From Nick:

This story has the following scripts that can all be in the folder for sell item to user

 
    1.)
    Script that runs when clicking the “Sell item to User” button in my_items.html:

        Script passes in item id  and target (recipient) user id as param

        checks that the target user is not the same as the currently logged in user (make sure not selling item to self)

        adds that item to the currently logged in user’s array of outgoing sale requests (finds the logged in user in accounts.json by matching the account’s id with the logged in user var in local_data.json)

    2.)
    Script that runs from incoming_sale_requests.html:

        Runs when the user clicks accept or reject sale request

        params: 

            string=”reject” or “accept

            item id

        no matter what the accept/reject string is, the script will remove the item from the logged in user’s incomingSaleRequests array

        if string = “accept”, item id will be added to the logged in user’s item array. if string = “reject”, do nothing

    3.)
    Script that runs from outgoing sale request html file, that cancels sale request

        params:

            target user id

        removes item from logged in user’s outgoing sale request array

        removes item from target user’s incoming sale request array