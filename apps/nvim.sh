#!/usr/bin/env bash

# set vars
SCRIPTPATH=$(dirname "${BASH_SOURCE[0]}");

# import config vars
source "${SCRIPTPATH}/../config.sh";

# neovim comes from the Brewfile

# the config is its own repo rather than vendored here, so it can be updated
# without a mac-setup release.
#
# it used to be cloned into ~/.dotfiles/.config/nvim and symlinked from there,
# because install.sh rsynced that directory and rsync would strip the clone's
# git linkage. install.sh no longer touches it -- ~/.dotfiles is now the
# hansohn/dotfiles checkout -- so the clone lands at its final location and the
# symlink is gone. Putting it back under ~/.dotfiles would leave an untracked
# directory inside that repo.
NVIM_REPO="https://github.com/hansohn/nvim"
nvim_dir="${HOME}/.config/nvim"
backup_dir="${HOME}/.dotfiles-bak/$(date +%Y%m%d)"

if [ -d "${nvim_dir}/.git" ]; then
  # --ff-only so local commits are reported rather than silently merged over
  echo "==> Updating neovim config in ${nvim_dir}";
  git -C "${nvim_dir}" pull --ff-only \
    || echo "==> Skipping: ${nvim_dir} has diverged from ${NVIM_REPO}";
else
  # a pre-1.0 install left a symlink here pointing into ~/.dotfiles. remove the
  # link rather than archiving it -- what it points at is archived by
  # apps/dotfiles.sh, and following it would move the clone out from under that.
  if [ -L "${nvim_dir}" ]; then
    echo "==> Removing stale symlink: ${nvim_dir}";
    rm "${nvim_dir}"
  elif [ -e "${nvim_dir}" ]; then
    echo "==> Archiving: ${nvim_dir} to ${backup_dir}/nvim";
    mkdir -p "${backup_dir}"
    mv "${nvim_dir}" "${backup_dir}/nvim"
  fi

  echo "==> Cloning ${NVIM_REPO} to ${nvim_dir}";
  mkdir -p "$(dirname "${nvim_dir}")"
  git clone "${NVIM_REPO}" "${nvim_dir}"
fi
