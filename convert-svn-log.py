#!/usr/bin/python3
#
# See https://github.com/svn-all-fast-export/svn2git/issues/146#issuecomment-1183011430
#
import sys
import re
import subprocess
import time
import os

timestampCSV = "timestamp.csv"
if not os.path.exists(timestampCSV):
    outCSV = open(timestampCSV, "w")
    outCSV.write(f"rev,timestamp\n")
else:
    outCSV = open(timestampCSV, "a")

logF = open("convert-svn-log.log", "a")
repoDir = "ttssh2"

allRevs = set()
allIssues = set()

revLogMatched = set()
issueLogMatched = set()
issueLogUnmatched = set()
targetRev = None

for line in sys.stdin:
    line = line.rstrip("\r").rstrip("\n")
    print(line)

    # ignore message by cvs2svn
    r = re.search('This commit was generated by cvs2svn to compensate for changes', line)
    if r:
        #sys.stderr.write(f"ignore: {line}\n")
        continue

    r = re.search(r"revision=(\d+)\b", line)
    if r:
        targetRev = r.group(1)

    # NG: -rXXX
    # NG: rXXX-
    # OK: rXXX-rYYY
    # OK: rXXX - rYYY
    # OK: (rXXX)
    # NG: rXXX_
    # OK: rXXX,
    # OK:  rXXX (space before and/or after revision)

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

now = time.time()
outCSV.write(f"{targetRev},{now}\n")

if allIssues:
    # print empty line for paragraph.
    print("")
    print("Issues:")
    for issue in sorted(list(allIssues), key=int):
        print(f"* https://osdn.net/projects/ttssh2/ticket/{issue}")

if allRevs:
    print("")
    print("Revisions:")
    listRevs = [ "r" + str(rev) for rev in sorted(list(allRevs)) ]
    logF.write(f"[r{targetRev}] Revisions:" + ", ".join(listRevs)  + "\n")
    isNotFound = False
    for rev in sorted(list(allRevs), key=int):
        try:
            cmd = ["git", "-C", repoDir, "log", "--all", "--grep", f"revision={rev}\b", "--format=%H"]
            result = subprocess.check_output(cmd)
            commitHash = result.decode()
            commitHash = commitHash.replace('\r', '').replace('\n', '')
            if commitHash != "":
                print(f"* r{rev}: {commitHash} https://osdn.net/projects/ttssh2/scm/svn/commits/{rev}")
            else:
                print(f"* r{rev}: NotFound  at r{targetRev} https://osdn.net/projects/ttssh2/scm/svn/commits/{rev}")
                logF.write(f"[r{targetRev}] commitHash for {rev} is empty\n")
                isNotFound = True

        except Exception as e:
            print(f"* r{rev}:")
            print(e)
            logF.write(f"[r{targetRev}] Exception:\n")
            logF.write(f"[r{targetRev}] * r{rev}:\n")
            logF.write(f"[r{targetRev}] " + str(e) + "\n")


    cmd = ["git", "-C", repoDir, "log", "--all"]
    cmd_str = " ".join(cmd)
    logF.write(f"[r{targetRev}]: $ {cmd_str}\n")
    result = subprocess.check_output(cmd).decode()
    with open(f"log-all-convert-svn-log.{targetRev}.log", "w") as f:
        for line in result.splitlines():
            f.write(f"[r{targetRev}]: {line}\n")

try:
    if targetRev is not None:
        cmd = ["git", "-C", repoDir, "show", "-s"]
        cmd_str = " ".join(cmd)
        logF.write(f"[r{targetRev}]: $ {cmd_str}\n")
        result = subprocess.check_output(cmd).decode()
        for line in result.splitlines():
            logF.write(f"[r{targetRev}]: {line}\n")
except Exception as e:
    print(f"* r{rev}:")
    print(e)
    logF.write(f"[r{targetRev}] Exception:\n")
    logF.write(f"[r{targetRev}] * r{rev}:\n")
    logF.write(f"[r{targetRev}] " + str(e) + "\n")
logF.write("-----------------------------------------------\n")
logF.close()

