#!/usr/bin/env bash
# Re-attribute the commits authored as "Claude <noreply@anthropic.com>" to Pardhu.
# Run on a FRESH CLONE of the team repo, never on a shared working copy.
# Usage: NEW_EMAIL=<email on Pardhu's GitHub account> ./reattribute.sh
set -euo pipefail
NEW_NAME="Pardhu Doppalapudi"
NEW_EMAIL="${NEW_EMAIL:?set NEW_EMAIL to the email verified on the GitHub account of Pardhu}"
export NEW_NAME NEW_EMAIL
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --env-filter '
if [ "$GIT_AUTHOR_EMAIL" = "noreply@anthropic.com" ]; then
  export GIT_AUTHOR_NAME="$NEW_NAME"; export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
fi
if [ "$GIT_COMMITTER_EMAIL" = "noreply@anthropic.com" ]; then
  export GIT_COMMITTER_NAME="$NEW_NAME"; export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
fi' -- main
