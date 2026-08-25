#!/usr/bin/env bash

# set vars
SCRIPTPATH=$(dirname "${BASH_SOURCE[0]}");

# import config vars
source "${SCRIPTPATH}/../config.sh";

# The dotfiles are their own repo rather than vendored here. They were a copy in
# dotfiles/ that had to be kept in step by hand, which is how the previous set
# drifted eight months out of date. They are also cross-platform -- the linux
# hosts this repo has nothing to say about use the same configs -- so they do
# not belong to a macOS setup script.
#
# hansohn/dotfiles owns the linking. Its install.sh archives anything real it
# would replace, and --bootstrap fetches what the configs need to load:
# oh-my-zsh, zsh-autosuggestions, zsh-syntax-highlighting, vim-plug and the vim
# plugins. Everything there is guarded, so re-running changes nothing.
DOTFILES_REPO="https://github.com/hansohn/dotfiles"
dotfiles_dir="${HOME}/.dotfiles"

if [ -d "${dotfiles_dir}/.git" ]; then
  # --ff-only so local commits are reported rather than silently merged over
  echo "==> Updating dotfiles in ${dotfiles_dir}";
  git -C "${dotfiles_dir}" pull --ff-only \
    || echo "==> Skipping: ${dotfiles_dir} has diverged from ${DOTFILES_REPO}";
else
  # a pre-1.0 install left a plain directory here, populated by rsync from
  # dotfiles/. archive it rather than cloning over the top -- the symlinks in
  # $HOME still point into it at this moment, and the dotfiles installer needs
  # to be the one to move them.
  if [ -e "${dotfiles_dir}" ]; then
    archive="${HOME}/.dotfiles.bak.$(date +%Y%m%d%H%M%S)"
    echo "==> Archiving: ${dotfiles_dir} to ${archive}";
    mv "${dotfiles_dir}" "${archive}"
  fi
  echo "==> Cloning ${DOTFILES_REPO} to ${dotfiles_dir}";
  git clone "${DOTFILES_REPO}" "${dotfiles_dir}"
fi

echo "==> Installing dotfiles";
"${dotfiles_dir}/install.sh" --bootstrap
