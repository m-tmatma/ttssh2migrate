#!/usr/bin/python3

import sys
import csv

input = sys.argv[1]
output = sys.argv[2]


with open(input, "r") as f_in, open(output, "w") as f_out:
    reader = csv.DictReader(f_in)
    for row in reader:
        user = row["user"]
        email = row["email"]

        # janesvnaccountname = Jane Doe <jane.doe@example.com>
        if email == "":
            email = f"{user}@example.com"
        data = f"{user} = {user} <{email}>"
        #print(data)
        f_out.write(data + "\n")

print(f"wrote {output}")
