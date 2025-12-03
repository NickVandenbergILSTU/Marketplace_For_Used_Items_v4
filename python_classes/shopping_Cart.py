import subprocess
import os

class Shopping_Account:
    def __init__(self):
        self.user = None
        self.itemListing = []

    def removeFromShoppingCart(self,userID, itemListing):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'remove_from_cart', 'remove_from_cart.sh')
        )
        subprocess.run(['bash', script_path,str(userID) ,str(itemListing)], check=True)
        return itemListing
    
    def checkoutShoppingCart(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'check_out_item', 'check_out_items.py')
        )
        subprocess.run(['python', script_path], check=True)
        return self.user

    def verifyMoneyBalanceAboveThreshold(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'verify_money_balance_above_threshold', 'verify_money_balance_above_threshold.sh')
        )
        subprocess.run(['bash', script_path], check=True)
    
