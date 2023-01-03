#!/usr/bin/python3

import sys
import csv

if len(sys.argv) != 3:
    print(f"{sys.argv[0]} input.csv output-identity-map")
    sys.exit(1)

input = sys.argv[1]
output = sys.argv[2]


with open(input, "r") as f_in, open(output, "w") as f_out:
    reader = csv.DictReader(f_in)
    for row in reader:
        svn_user = row["svn_user"]
        git_user = row["git_user"]
        email = row["email"]

        # example:
        #   janesvnaccountname = Jane Doe <jane.doe@example.com>
        data = f"{svn_user} = {git_user} <{email}>"
        #print(data)
        f_out.write(data + "\n")

print(f"wrote {output}")
