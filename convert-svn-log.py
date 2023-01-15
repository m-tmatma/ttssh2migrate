#!/usr/bin/python3
#
# See https://github.com/svn-all-fast-export/svn2git/issues/146#issuecomment-1183011430
#
import sys
import re
import subprocess
import csv
import os

def get_log(repoDir, git_hash):
    cmd = ["git", "-C", repoDir, "log", "-n", "1", git_hash]
    return subprocess.check_output(cmd).decode()

def get_svn_rev(repoDir, git_hash):
    result = get_log(repoDir, git_hash)
    for line in result.splitlines():
        match = re.search(r'revision=(\d+)$', line)
        if match:
            svn_rev = int(match.group(1))
            return svn_rev
    return None

def get_rev_hash_map(repoDir):
    # all revision list
    cmd = ["git", "-C", repoDir, "rev-list", "--all"]
    result = subprocess.check_output(cmd).decode()
    all_git_hash = { line for line in result.splitlines() }
    with open(f"git-hash-list.log", "w") as f:
        for line in all_git_hash:
            f.write(f"{line}\n")

    csv_file = 'svn-rev-to-git-hash-map.csv'

    cached_git_hash = set()
    revision_to_hash_map = {}

    # read csv
    if os.path.exists(csv_file):
        with open(csv_file, "r") as f:
            reader = csv.DictReader(f)
            for row in reader:
                svn_rev  = row["svn_rev"]
                git_hash = row["git_hash"]
                revision_to_hash_map[svn_rev] = git_hash
                cached_git_hash.add(git_hash)

    target_to_get_hash = all_git_hash - cached_git_hash
    for git_hash in target_to_get_hash:
        svn_rev = get_svn_rev(repoDir, git_hash)
        revision_to_hash_map[svn_rev] = git_hash

    with open(csv_file, "w") as f:
        writer = csv.DictWriter(f, ['svn_rev', 'git_hash'])
        writer.writeheader()
        for svn_rev, git_hash in revision_to_hash_map.items():
            writer.writerow({'svn_rev' : svn_rev, 'git_hash' : git_hash})
    return revision_to_hash_map

repoDir = "ttssh2"

allRevs = set()
allIssues = set()

revLogMatched = set()
issueLogMatched = set()
issueLogUnmatched = set()

try:
    revision_to_hash_map = get_rev_hash_map(repoDir)
except Exception as e:
    with open("log.log", "a") as f:
        f.write(f"{e}\n")
    raise

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
        if rev in revision_to_hash_map:
            commitHash = revision_to_hash_map[rev]
            print(f"* r{rev}: {commitHash} https://osdn.net/projects/ttssh2/scm/svn/commits/{rev}")
        else:
            print(f"* r{rev}: NotFound https://osdn.net/projects/ttssh2/scm/svn/commits/{rev}")

