#!/bin/bash
if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    BASE_COMMIT=$(git rev-parse $TRAVIS_BRANCH)
    echo "Running clang-format-3.8 against branch $TRAVIS_BRANCH, with hash $BASE_COMMIT"
    COMMIT_FILES=$(git diff --name-only $BASE_COMMIT | grep -i -v LinkDef)
    RESULT_OUTPUT="$(git clang-format-3.8 --commit $BASE_COMMIT --diff --binary `which clang-format-3.8` $COMMIT_FILES)"

    if [ "$RESULT_OUTPUT" == "no modified files to format" ] \
      || [ "$RESULT_OUTPUT" == "clang-format-3.8 did not modify any files" ] ; then
      echo "clang-format-3.8 passed. \o/"
      exit 0
    else
      echo "clang-format failed."
      echo "To reproduce it locally please run: "
      echo -e "\t1) git checkout $TRAVIS_PULL_REQUEST_BRANCH"
      echo -e "\t2) git clang-format-3.8 --commit $BASE_COMMIT --diff --binary $(which clang-format-3.8)"
      echo "$RESULT_OUTPUT"
      exit 1
    fi
fi
