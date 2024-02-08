#!/bin/bash
# This script clones the glideinWMS factory repos into /opt/.
# It looks for the repo and branch names into the ENV VARS.
# The pattern GWMS_FACTORY_REPO_[0-9]+ specifies the repo and
# GWMS_FACTORY_BRANCH_[0-9]+ specifies the branch. If the later is not found
# the default "master" branch is used instead

pushd /opt/

echo "Cloning repos..."
for i in `printenv | grep GWMS_FACTORY_REPO`;
do
        REPO=`echo $i | awk -F "=" '{print $2}'`;
        INDEX=`echo $i | awk -F "=" '{print $1}' | grep  -oEi '[0-9]+'`;
        echo "Cloning repo: "$REPO;
        BRANCH_VAR="GWMS_FACTORY_BRANCH_"$INDEX;
        BRANCH=`printenv | grep "$BRANCH_VAR" | awk -F "=" '{print $2}'`
        if [ -z "$BRANCH" ]
        then
                echo "Branch not set, using: 'master'"
                git clone --single-branch --branch "master" "$REPO";
        else
                echo "Branch set to : "$BRANCH;
                git clone --single-branch --branch "$BRANCH" "$REPO";
        fi;
done
echo "Done cloning repos..."

popd
