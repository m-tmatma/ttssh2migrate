#!/usr/bin/python3
#
# See https://github.com/svn-all-fast-export/svn2git/issues/146#issuecomment-1183011430
#
import sys
import re
import subprocess
import os

script_dir = os.path.dirname(__file__)
git_log_grep_py = os.path.join(script_dir, 'git-log-grep.sh')

repoDir = "ttssh2"

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

if allIssues:
    # print empty line for paragraph.
    print("")
    print("Issues:")
    for issue in sorted(list(allIssues), key=int):
        print(f"* https://osdn.net/projects/ttssh2/ticket/{issue}")

if allRevs:
    print("")
    print("Revisions:")
    for rev in sorted(list(allRevs), key=int):
        try:
            #cmd = ["git", "-C", repoDir, "log", "--all", f"--grep=revision={rev}$", "--format=%H"]
            cmd = ["sh", git_log_grep_py, repoDir, str(rev)]
            result = subprocess.check_output(cmd)
            commitHash = result.decode()
            commitHash = commitHash.replace('\r', '').replace('\n', '')
            if commitHash != "":
                print(f"* r{rev}: {commitHash} https://osdn.net/projects/ttssh2/scm/svn/commits/{rev}")
            else:
                print(" ".join(cmd))
                print(f"* r{rev}: NotFound https://osdn.net/projects/ttssh2/scm/svn/commits/{rev}")
        except Exception as e:
            print(f"* r{rev}:")
            print(e)
