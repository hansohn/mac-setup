#!/usr/bin/env bash

# set vars
SCRIPTPATH=$(dirname "${BASH_SOURCE[0]}");

# import config vars
source "${SCRIPTPATH}/../config.sh";

# git comes from the Brewfile.
#
# The shared settings live in hansohn/dotfiles as git/gitconfig and are
# symlinked by its installer, so they converge on every run. They used to be
# written here with
# `git config --global` behind an `if [ ! -f ~/.gitconfig ]` guard, which meant
# they landed once on a fresh machine and never again -- any setting added
# later never reached a machine that already had a gitconfig.
#
# Identity is the one part that cannot ship in a public repo, so it stays here
# and is derived from config.sh into ~/.gitconfig.local, which the tracked
# .gitconfig pulls in with [include].

gitconfig_local="${HOME}/.gitconfig.local"

if [ -z "${GIT_USER_NAME}" ] || [ -z "${GIT_USER_EMAIL}" ]; then
  echo "==> Skipping git identity (GIT_USER_NAME or GIT_USER_EMAIL unset in config.sh)" >&2
  return 0 2>/dev/null || exit 0
fi

echo "==> Configuring git identity in ${gitconfig_local}"

# --file rewrites just these two keys and leaves anything else in the file
# alone, so this is idempotent and safe to re-run
git config --file "${gitconfig_local}" user.name "${GIT_USER_NAME}";
git config --file "${gitconfig_local}" user.email "${GIT_USER_EMAIL}";
