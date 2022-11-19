#!/usr/bin/python3
import sys

data = set()
for line in sys.stdin:
    if line not in data:
        print(line.rstrip("\r").rstrip("\n"))
        data.add(line)
