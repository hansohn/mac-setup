<div align="center">
  <h1>mac-setup</h1>
  <p>Opinionated macOS setup for infrastructure and platform engineering</p>
  <p>
    <!-- Build Status -->
    <a href="https://github.com/hansohn/mac-setup/actions/workflows/shellcheck.yml"><img src="https://img.shields.io/github/actions/workflow/status/hansohn/mac-setup/shellcheck.yml?style=for-the-badge"></a>
    <!-- Github Tag -->
    <a href="https://github.com/hansohn/mac-setup/tags/"><img src="https://img.shields.io/github/v/tag/hansohn/mac-setup?style=for-the-badge&sort=semver"></a>
    <!-- License -->
    <a href="https://github.com/hansohn/mac-setup/blob/main/LICENSE.md"><img src="https://img.shields.io/github/license/hansohn/mac-setup.svg?style=for-the-badge"></a>
  </p>
</div>

## Description

This repo sets up a macOS machine for infrastructure and platform work — the Terraform, Ansible, Kubernetes and AWS toolchains, plus the shell, editor and terminal configuration I use daily. Like most setup repos it is a continuous work in progress, updated as the systems I work on evolve and my tool preferences change.

What's Included
---------------

Everything installable is declared in [`Brewfile`](Brewfile) — formulae, casks, Mac App Store apps and taps — and installed by `install.sh` with a single `brew bundle install`. What follows is a summary by area, not an inventory.

### Command line

| Area | Tools |
|---|---|
| Cloud & Kubernetes | `awscli`, `aws-vault`, `doctl`, `gcloud-cli`, `helm`, `k9s`, `kind`, `kubernetes-cli`, `kubectx`, `kustomize`, `argocd`, `eksctl`, `cfn-lint`, `session-manager-plugin` |
| Infrastructure as code | `terraform`, `terragrunt`, `terraform-docs`, `terraform-ls`, `tflint`, `tfsec`, `packer`, `vagrant`, `ansible`, `ansible-lint` |
| Shell & editors | `zsh` with oh-my-zsh, `bash`, `neovim`, `macvim`, `tmux`, `git`, `lazygit`, `gh`, `tree-sitter` |
| Search & files | `fzf`, `ripgrep`, `fd`, `bat`, `tree`, `grep`, `jq`, `curl`, `wget`, `1password-cli` |
| Languages | `go`, `lua`, `maven`, `pyenv`, `nvm`, `uv`; Rust via `rustup`, installed by [`apps/rust.sh`](apps/rust.sh) |
| Linting | `shellcheck`, `yamllint`, `jsonlint`, `golangci-lint`, `selene` |

### AI

`opencode`, `ollama` and `claude` (Claude Code) on the command line, plus the ChatGPT desktop app.

### Applications

1Password, Adobe Acrobat Reader, AppCleaner, Discord, Docker Desktop, Firefox, Ghostty, Google Chrome, Google Drive, iTerm2, Microsoft Teams, Obsidian, Postman, Raycast, Rectangle, Signal, Slack, Spotify, VirtualBox, Visual Studio Code, Wireshark and Zoom, plus the Hack Nerd Font and the Zulu 21 JDK.

From the Mac App Store: Amphetamine, Decompressor, iMazing HEIC Converter and Kindle.

### Configured, not installed

The scripts in [`apps/`](apps) install nothing. They run after `brew bundle` and only configure: `git` identity and defaults, `bash`, `zsh` with oh-my-zsh, `vim` with vim-plug and its plugins, Rust via `rustup`, iTerm2 shell integration and colour schemes, the macOS Terminal colorscheme, and vagrant plugins.

Two exceptions. [`apps/homebrew.sh`](apps/homebrew.sh) installs Homebrew itself, the one thing that cannot come from a Brewfile. [`apps/nvim.sh`](apps/nvim.sh) clones [hansohn/nvim](https://github.com/hansohn/nvim) — the Neovim config is its own repo rather than vendored here, so it can be updated without a change to this one — and links it to `~/.config/nvim`.

macOS defaults — Dock, Finder, screenshots, firewall, timezone — are applied from [`customizations/`](customizations).

### Keeping it honest

```sh
make brew/check     # declared but missing or outdated
make brew/drift     # installed but NOT declared
make brew/dump      # regenerate the Brewfile from this machine
```

### Profiles

The base [`Brewfile`](Brewfile) is what every machine gets. Two optional
overlays install on top of it:

| file | tracked | applies to |
|---|---|---|
| `Brewfile.work` | yes | every machine the employer owns |
| `Brewfile.personal` | yes | every machine you own |
| `Brewfile.local` | **no** | this one machine |

Set `PROFILE="work"` or `PROFILE="personal"` in `config.sh` to select one.
`Brewfile.local` needs no setting — it is applied last whenever it exists, so a
one-off always wins over the profile.

The profile files are tracked deliberately. They are what makes a replacement
laptop reproduce from the repo rather than from memory. `Brewfile.local` is
gitignored, because by definition it suits nothing but the machine it is on.

The test for which to use: *if this laptop died tomorrow, would I want this on
the replacement?* Yes means a profile, no means `Brewfile.local`.

`make brew/drift` is the one worth running periodically. It answers "what did I install months ago and never write down" — which is how the previous hand-maintained list fell years out of date.

### Dotfiles

The dotfiles are their own repo, [hansohn/dotfiles](https://github.com/hansohn/dotfiles). `apps/dotfiles.sh` clones it to `~/.dotfiles` and runs its installer, which owns the linking. They were a vendored copy here until 1.0; keeping two copies in step by hand is how the previous set drifted eight months out of date, and the configs are cross-platform, so they do not belong to a macOS setup script.

It covers the shell (`~/.zshenv`, `~/.zprofile`, `~/.zshrc`), the editor (`~/.vimrc`, `~/.vim/plugins.vim`), git (`~/.gitconfig`, `~/.config/git/ignore`), and the configs for tmux, ghostty, k9s, bat, gh, ssh, terraform and more. See that repo for the full list.

`--bootstrap` is passed, so it also fetches what those configs need in order to load: oh-my-zsh, `zsh-autosuggestions`, `zsh-syntax-highlighting`, vim-plug and the vim plugins.

**Anything already at those paths is moved**, not merged, to a dated backup directory — so if you want a previous config back, that is where it is. Paths already symlinked are left alone.

The neovim config is separate again: [hansohn/nvim](https://github.com/hansohn/nvim), cloned directly to `~/.config/nvim` by `apps/nvim.sh`.

### Color palettes

- [solarized](https://ethanschoonover.com/solarized/)
- [tokyonight](https://github.com/folke/tokyonight.nvim)

Prerequisites
-------------

[`preflight.sh`](preflight.sh) handles the host prerequisites and is sourced by the installer, so there is nothing to run by hand. It installs the [Command line Tools for Xcode](https://developer.apple.com/xcode/) if they are absent — Homebrew and several other tools require them — waiting for the GUI installer to finish rather than racing it, and caches sudo for the length of the run so `customizations/` does not stop for a password an hour in.

Rosetta 2 is opt-in. No cask in the [`Brewfile`](Brewfile) needs it; it is worth installing only for Docker Desktop's *"Use Rosetta for x86/amd64 emulation"* setting, which speeds up `linux/amd64` containers on Apple Silicon. Enable it with `ROSETTA_ENABLED="true"` in `config.sh`.

Two things still have to happen by hand before you start. Sign into the **App Store**, or the four `mas` entries in the Brewfile will fail — `mas signin` has not worked since macOS 10.13. And you will need **Administrator permissions** throughout.

Installation
------------

Note that this replaces your shell and editor configuration — see [Dotfiles](#dotfiles) for exactly which paths are affected and where the originals are archived.

```bash
# clone the repo
$ git clone https://github.com/hansohn/mac-setup.git
$ cd mac-setup

# create your config -- config.sh is gitignored, so this repo never carries a
# real name or address. the installer refuses to run without it.
$ cp config.sh.example config.sh && vi config.sh

# execute the installer
$ ./install.sh
```

`install.sh` is safe to re-run. Every step is guarded, so running it again updates an existing machine rather than reinstalling it. Enjoy!

### Naming conventions

Settings in `config.sh` follow four rules, so a new one has an obvious name:

| Rule | |
|---|---|
| Case marks scope | `UPPER_SNAKE` for config and constants, `lower_snake` for a script's internal working variables |
| Domain first | `<DOMAIN>_<ATTRIBUTE>`, e.g. `GIT_USER_NAME`, `GIT_USER_EMAIL`. Group by subject, not by verb, so everything about one tool sorts together |
| Booleans end in `_ENABLED` | `ROSETTA_ENABLED`, `RUST_NIGHTLY_ENABLED`. Read through `is_enabled()` in [`lib.sh`](lib.sh), which accepts `true`/`yes`/`on`/`1` in any case |
| Paths carry a type suffix | `_DIR` for a directory, `_FILE` for one file, `_PATH` for a colon-separated list. No abbreviations — `_LOC` is ambiguous |

One exception: a variable another tool defines keeps that tool's name. `SHOW_AWS_PROMPT` and `DEFAULT_USER` are read by oh-my-zsh, so renaming them to fit the table would silently disable what they control.

Anything early in the run must stay **bash 3.2 compatible** — `/bin/bash` on a factory Mac is 3.2.57, and [`preflight.sh`](preflight.sh) executes before Homebrew installs bash 5. No `${var,,}`, `mapfile`, or associative arrays there.
