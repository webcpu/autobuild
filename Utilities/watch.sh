#!/bin/bash
#set -x
#Check if fswatch is installed
if which fswatch >/dev/null; then
  echo "fswatch is found"
else
  echo "fswatch does not exist, install it using the command below."
  echo "brew install fswatch"
  exit 1
fi

#Configure the directory to be monitored
dir=$PWD
if [ $# -gt 0 ]; then
  if [[ "$1" = /* ]]; then
    #absolute path
    dir=$1
  else
    #relative path
    dir=$(PWD)/$(basename "$1")
  fi
  #  absolutepath dir 2>/dev/null
fi
echo "Monitoring directory: $dir"

#Monitor file changes
fswatch -0 $dir | while read -d "" event
do
  if [[ $event == *.swift ]]
  then
    echo "$event"
    echo "Building"
    cd ${dir}; ./Utilities/build.sh
  fi
done

