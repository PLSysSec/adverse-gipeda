#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: ./bench-range.sh START END"
  echo "  where START and END specify git commits"
  echo "  in any way accepted by git, e.g. hashes,"
  echo "  branch names, tags, etc."
  exit 1
fi

# Check overall load to ensure we're (mostly) idle for good benchmarking
source idledetect.sh
if [ `idlepct` -lt 95 ]; then
  echo "not idle enough"
  exit 1
fi

git -C repository fetch --all -t
start=$1
if [ $# -eq 1 ]; then end=origin/master; else end=$2; fi
touch badcommits

while read -r rev; do
  revhash=`git -C repository rev-parse $rev`
  echo "Benchmarking commit $revhash"
  if grep --quiet "^$revhash$" badcommits; then
    echo "  This commit known to fail benchmarking. Moving on."
  else
    ./bench-commit.sh $revhash >/dev/null
    if [ $? -ne 0 ]; then
      echo "  Benchmarking failed for this commit. Trying again..."
      ./bench-commit.sh $revhash >/dev/null
      if [ $? -ne 0 ]; then
        echo $revhash >> badcommits
        echo "  Failed again. Moving on."
      else
        echo "  Succeeded on the second try."
      fi
    fi
  fi
done < <(git -C repository rev-list "$start..$end")
