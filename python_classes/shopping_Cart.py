import subprocess
import os

class Shopping_Account:
    def __init__(self):
        pass

    def removeFromShoppingCart(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'remove_from_shopping_cart', 'remove_from_shopping_cart.sh')
        )
        subprocess.run(['bash', script_path], check=True)

    def checkoutShoppingCart(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'checkout_shopping_cart', 'checkout_shopping_cart.sh')
        )
        subprocess.run(['bash', script_path], check=True)

    def verifyMoneyBalanceAboveThreshold(self):
        # Get absolute path to the shell script
        script_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '..', 'use_cases', 'verify_money_balance_above_threshold', 'verify_money_balance_above_threshold.sh')
        )
        subprocess.run(['bash', script_path], check=True)
    
    