#!/usr/bin/python3
import sys
import re

allRevs = set()
allIssues = set()
for line in sys.stdin:
    r = re.finditer(r"(r(\d+)\s*-\s*r(\d+))|(r(\d+)((?=[^0-9-&/=@_])|$))", line)
    for m in r:
        matched = m.group(0)
        revs = re.split(r'\s*-\s*', matched)
        for rev in revs:
            allRevs.add(rev.replace("r", ""))
    print(line.rstrip("\r").rstrip("\n"))

    r = re.finditer(r"(#(\d+))((?=[^0-9-&/=@_])|$)", line)
    for m in r:
        issue = m.group(0)
        allIssues.add(issue.replace("#", ""))

if allRevs:
    # print empty line for paragraph.
    print("")
    print("Revisions:")
    for rev in sorted(list(allRevs)):
        print(f"* https://osdn.net/projects/ttssh2/scm/svn/commits/{rev}")

if allIssues:
    # print empty line for paragraph.
    print("")
    print("Issues:")
    for issue in sorted(list(allIssues)):
        print(f"* https://osdn.net/projects/ttssh2/ticket/{issue}")
