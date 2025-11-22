#!/usr/bin/env python3
"""
add_numbers.py - Add two numbers and return the sum
Usage: python3 add_numbers.py <number1> <number2>
"""

import sys

def add_numbers(num1, num2):
    """Add two numbers and return the result."""
    try:
        result = float(num1) + float(num2)
        return result
    except ValueError as e:
        print(f"Error: Invalid number format - {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 add_numbers.py <number1> <number2>", file=sys.stderr)
        sys.exit(1)
    
    num1 = sys.argv[1]
    num2 = sys.argv[2]
    
    result = add_numbers(num1, num2)
    print(result)