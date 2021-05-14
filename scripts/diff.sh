#!/bin/bash

if [ $# -ne 3 ];
    then echo "args required: source repo, source dir, target dir"
    exit 1
fi

# We will get our files from the source repo/dir.
sourceDir="$1"/"$2"

# We will copy these files to destination dir.
destDir="$3"

# Create our destination dir in case it does not yet exist, because we cannot
# diff a directory that does not exist.
mkdir -p "$destDir"

# Copy everything from source to destination, replacing what's there.
cp -a "$sourceDir"/* "$destDir"

# Remove the source repo that we cloned.
rm -rf "$1"

# If our sync has resulted in any changes, set an output for the rest of our
# workflow.
if [ -n "$(git status --porcelain)" ];
  then echo ::set-output name=have_diff::"true"
fi
