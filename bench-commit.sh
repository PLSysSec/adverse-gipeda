#!/bin/bash

git -C repository fetch --all -t
if [ $# -eq 0 ]; then rev=origin/master; else rev=$1; fi
githash=`git -C repository rev-parse $rev`
mkdir -p logs
logfile=`realpath logs/$githash.log`

if [ -e $logfile ]; then
  echo "This commit already benchmarked."
else
  echo "Running benchmarks..."
  cd repository
  git checkout $rev
  stack clean  # for accurate count of build warnings
  stack bench --no-terminal 2> $logfile
  if [ $? -ne 0 ]; then
    echo "running benchmarks failed"
    rm $logfile
    exit 1
  fi
  cd ..
fi

echo "Generating HTML report..."
stack exec gipeda -- -j4 || exit 1

echo "All done. View results by pointing a browser at site/index.html."
