#!/bin/bash
set -e

MANUAL_PUSH=${MANUAL_PUSH:-0}

"${ROOT_DIR}"/scripts/build.sh

git branch -D gh-pages || true

git checkout --orphan gh-pages

cp -rfv site/public/* ./

git rm -rf site/

git add .

git commit -m "Update documentation" .

if [ ${MANUAL_PUSH} = "1" ] ; then
  #git push -ff
  git push --set-upstream origin gh-pages -ff
fi
