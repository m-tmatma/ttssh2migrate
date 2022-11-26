#!/usr/bin/python3
import sys
import re

allRevs = set()
allIssues = set()
for line in sys.stdin:
    line = line.rstrip("\r").rstrip("\n")
    print(line)

    # ignore message by cvs2svn
    r = re.search('This commit was generated by cvs2svn to compensate for changes', line)
    if r:
        #sys.stderr.write(f"ignore: {line}\n")
        continue

    r = re.finditer(r"\b(r(\d+)\s*-\s*r(\d+))|\b(r(\d+)((?=[^a-zA-Z0-9-&/=@_])|$))", line)
    for m in r:
        matched = m.group(0)
        revs = re.split(r'\s*-\s*', matched)
        for rev in revs:
            allRevs.add(rev.replace("r", ""))
        sys.stderr.write(f"match rev: {line}\n")

    r = re.finditer(r"(\w*)#(\d+)((?=[^a-zA-Z0-9-&/=@_])|$)", line)
    for m in r:
        prefix = m.group(1)
        issue  = m.group(2)
        if prefix == "" or prefix == "SVN":
            allIssues.add(issue.replace("#", ""))
            sys.stderr.write(f"match issue: {line}\n")
        else:
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
