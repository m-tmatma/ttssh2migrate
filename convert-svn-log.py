#!/usr/bin/python3
#
# See https://github.com/svn-all-fast-export/svn2git/issues/146#issuecomment-1183011430
#
import sys
import re
import os
import subprocess

allRevs = set()
allIssues = set()

revLogMatched = set()
issueLogMatched = set()
issueLogUnmatched = set()

for line in sys.stdin:
    line = line.rstrip("\r").rstrip("\n")
    print(line)

    # ignore message by cvs2svn
    r = re.search('This commit was generated by cvs2svn to compensate for changes', line)
    if r:
        #sys.stderr.write(f"ignore: {line}\n")
        continue

    # NG: -rXXX
    # NG: rXXX-
    # OK: rXXX-rYYY
    # OK: rXXX - rYYY
    # OK: (rXXX)
    # NG: rXXX_
    # OK: rXXX,
    # OK:  rXXX (space before and/or after revsion)

    revRange = r"r(\d+)\s*-\s*r(\d+)"
    revOne   = r"r(\d+)"
    endMark  = r"((?=[^0-9-&/=@_])|$)"
    pattern  = "(" + revRange + ")" + "|" + r"(\b" + revOne + endMark  + ")"

    r = re.finditer(pattern, line)
    for m in r:
        matched = m.group(0)
        revs = re.split(r'\s*-\s*', matched)
        for rev in revs:
            allRevs.add(rev.replace("r", ""))
        if line not in revLogMatched:
            revLogMatched.add(line)
            sys.stderr.write(f"match rev: {line}\n")

    # NG: Run-Time Check Failure #3
    r = re.finditer(r"(\w*)(?<!Run-Time Check Failure )#(\d+)((?=[^0-9-&/=@_])|$)", line)
    for m in r:
        prefix = m.group(1)
        issue  = m.group(2)
        if prefix == "" or prefix == "SVN":
            allIssues.add(issue.replace("#", ""))
            if line not in issueLogMatched:
                issueLogMatched.add(line)
                sys.stderr.write(f"match issue: {line}\n")
        else:
            if line not in issueLogUnmatched:
                issueLogUnmatched.add(line)
                sys.stderr.write(f"ignore issue: {line}\n")

if allRevs:
    # print empty line for paragraph.
    print("")
    print("Revisions:")
    for rev in sorted(list(allRevs), key=int):
        print(f"* https://osdn.net/projects/ttssh2/scm/svn/commits/{rev}")

if allIssues:
    # print empty line for paragraph.
    print("")
    print("Issues:")
    for issue in sorted(list(allIssues), key=int):
        print(f"* https://osdn.net/projects/ttssh2/ticket/{issue}")

if allRevs:
    print("")
    print("commitHashes:")
    for rev in sorted(list(allRevs), key=int):
        cmd = f"git log --grep 'revision={rev}$' --format='%H'"
        result = subprocess.call(cmd.split())
        print(f"* {rev}: {result}")

    # print("PWD: ", os.getcwd())
    # # example
    # # :1 36f35d4e45715ce138189ef27890e5230fb764e6
    # # :2 d45bc04496d06b1f809dcd2313b0919d0b9a078f
    # # :3 a61a858e55ed03638a09e10ddfec7dbbc3ee4b2f
    # # :4 05ea405d4ff4dd55b9fa2b62a3ffeb2d6d9f326b
    # # :5 fa0c196e7c2dbc0fe29fed29478386c6279b5971
    # RevMaps = {}
    # marks = r"ttssh2/marks-ttssh2"
    # try:
    #     with open(marks, "r") as fin:
    #         for line in fin:
    #             data = line.split()
    #             rev = data[0].replace(':', '')
    #             commitHash = data[1]
    #             RevMaps[rev] = commitHash

    #     print("")
    #     print("commitHashes:")
    #     for rev in sorted(list(allRevs), key=int):
    #         commitHash = RevMaps.get(str(rev), "not found")
    #         print(f"* {rev}: {commitHash}")
    # except Exception as e:
    #     print("[Exception]")
    #     print(e)
