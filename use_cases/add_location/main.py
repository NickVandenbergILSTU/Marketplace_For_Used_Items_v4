import sys
import os

# Add python_classes folder to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_classes'))

from LoactionList import Location_List


if len(sys.argv) != 2:
    print("Usage: python main.py <location_name>")
    sys.exit(1)

location_name = sys.argv[1]

# Create a Location_List instance and add location
location_list = Location_List()
location_list.addLocation(location_name)