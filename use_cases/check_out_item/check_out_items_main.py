import os
import sys
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from shopping_Cart import Shopping_Account

cart = Shopping_Account()

cart.checkoutShoppingCart()
