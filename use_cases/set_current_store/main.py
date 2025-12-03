import sys
import os

# Add python_classes folder to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from storeLocation import Store_Location


if len(sys.argv) != 2:
    print("Usage: python main.py <store_id>")
    sys.exit(1)

store_id = sys.argv[1]

# Create a Store instance and select store
store = Store_Location()
store.selectStore(store_id)