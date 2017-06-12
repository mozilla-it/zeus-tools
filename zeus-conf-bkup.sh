#!/bin/sh

# This is meant to be used as a shell script invoked in a cron for backing up
# the current state of the conf/ folder in zeus' install path.

#provide correct path to override the following two positional arguments
CONF=${1:-~/zeus-conf}
BKUP=${2:-~/zeus-bkup}

if ! hash git 2> /dev/null; then
    echo "git not installed!"
    exit 1
fi
if ! hash rsync 2> /dev/null; then
    echo "rsync not installed!"
    exit 1
fi



mkdir -p $BKUP
rsync -rav --delete --exclude=.git/ $CONF/ $BKUP/
cd $BKUP
if [ "true" != "`git rev-parse --is-inside-work-tree 2> /dev/null`" ]; then
    git init
fi
git add .
MSG="`git status --short`"
if [ "$MSG" ]; then
    git commit -m "$MSG"
fi
