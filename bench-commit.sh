#!/bin/bash

git -C repository fetch --all -t
git -C repository checkout -q master
git -C repository pull
if [ $# -eq 0 ]; then rev=origin/master; else rev=$1; fi
githash=`git -C repository rev-parse $rev`
mkdir -p logs
logfile=`realpath logs/$githash.log`

if [ -e $logfile ]; then
  echo "This commit already benchmarked."
else
  echo "Running benchmarks..."
  cd repository
  git checkout -q $rev
  stack clean  # for accurate count of build warnings
  stack bench --no-terminal 2> $logfile.tmp
  if [ $? -ne 0 ]; then
    echo "running benchmarks failed"
    # rm $logfile.tmp  # actually, if we leave logfile.tmp around, we can troubleshoot the benchmark
    exit 1
  fi
  mv $logfile.tmp $logfile  # so we don't get an incomplete log in $logfile.  All or nothing
  cd ..
fi

echo "Generating HTML report..."
stack exec gipeda -- -j4 || exit 1

echo "All done. View results by pointing a browser at site/index.html."
