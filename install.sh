#!/usr/bin/env bash

# set vars
SCRIPTPATH=$(dirname "${BASH_SOURCE[0]}")

# import config vars -- config.sh is gitignored, so a fresh clone does not have
# one. fail loudly here rather than letting apps/git.sh write the placeholder
# identity from config.sh.example onto the machine.
if [ ! -f "${SCRIPTPATH}/config.sh" ]; then
  echo "==> Error: config.sh is missing." >&2
  echo "    cp ${SCRIPTPATH}/config.sh.example ${SCRIPTPATH}/config.sh" >&2
  echo "    then edit it with your name, email and timezone." >&2
  exit 1
fi
source "${SCRIPTPATH}/config.sh"

# shared helpers -- must come before preflight.sh, which uses is_enabled()
source "${SCRIPTPATH}/lib.sh"

# host prerequisites: xcode command line tools, optional rosetta, sudo keepalive.
# sourced rather than executed -- see the note at the top of preflight.sh
source "${SCRIPTPATH}/preflight.sh"

# ----- personalization -----

source "${SCRIPTPATH}/customizations/system-settings.sh"
source "${SCRIPTPATH}/customizations/user-settings.sh"

# ----- apps -----

# list apps for customized install
apps=(
  # first, so the shell and editor config is in place before anything reads it
  "dotfiles"
  "git"
  "iterm2"
  "macos-terminal"
  "nvim"
  "rust"
  "vagrant"
)

# install homebrew first -- everything below it depends on brew being present
# shellcheck disable=SC1090
source "${SCRIPTPATH}/apps/homebrew.sh"

# install packages
# brew bundle handles taps, formulae, casks and mas entries, and is idempotent,
# so no per-package guards are needed here
echo "==> Installing packages from Brewfile"
brew bundle install --file="${SCRIPTPATH}/Brewfile"

# Optional overlays, both additive on top of the base list above.
#
#   Brewfile.<profile>  tracked, selected by PROFILE in config.sh. What every
#                       machine of that kind should have, so a replacement
#                       laptop reproduces from the repo.
#   Brewfile.local      gitignored, this machine only. Applied last so a
#                       one-off always wins.
#
# Deliberately separate `brew bundle install` calls rather than conditionals
# inside the Brewfile: the Brewfile is evaluated as ruby, but neither that nor
# which environment variables survive homebrew's scrubbing is documented, and
# a change to either would fail silently by installing the wrong set.
# A named profile that has no file is almost always a typo in config.sh, so say
# so. Brewfile.local is genuinely optional and stays quiet when absent.
if [ -n "${PROFILE:-}" ] && [ ! -f "${SCRIPTPATH}/Brewfile.${PROFILE}" ]; then
  echo "==> Warning: PROFILE is '${PROFILE}' but ${SCRIPTPATH}/Brewfile.${PROFILE} does not exist" >&2
fi

for overlay in "${PROFILE:-}" local; do
  [ -n "${overlay}" ] || continue
  overlay_file="${SCRIPTPATH}/Brewfile.${overlay}"
  [ -f "${overlay_file}" ] || continue
  echo "==> Installing packages from Brewfile.${overlay}"
  brew bundle install --file="${overlay_file}"
done

# configure applications
# these run after brew bundle because several of them configure an application
# that brew bundle is what installs
# shellcheck disable=SC1090
for app in "${apps[@]}"; do
  source "${SCRIPTPATH}/apps/${app}.sh"
done
