# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased](unreleased)

## [1.0.0](https://github.com/hansohn/mac-setup/compare/0.9.0..1.0.0) (Aug 26, 2026)

FEATURES:

- the package list splits into profiles. Brewfile is the shared baseline;
  Brewfile.work and Brewfile.personal are tracked overlays selected by PROFILE
  in config.sh; Brewfile.local is gitignored and applied last, for one machine
  only. Previously a single list meant a work machine got Discord, Signal and
  the rest along with everything else. Implemented as separate `brew bundle
  install` calls rather than conditionals inside the Brewfile -- the Brewfile
  is evaluated as ruby and conditionals do work, but neither that nor which
  environment variables survive homebrew's scrubbing is documented, and a
  change to either would fail silently by installing the wrong set
- moved to Brewfile.personal: doctl, hashicorp/tap/packer, tor-browser,
  ubiquiti-unifi-controller, discord, signal and Kindle. The hashicorp tap
  declaration stays in the base list, since terraform needs it there
- yamlfmt is declared and wired up. yaml was linted but never formatted:
  yamllint reported that indentation was wrong and nothing fixed it. yaml is
  the filetype this repo is built around, and was the only one in the neovim
  config with no formatter attached while markdown had three
- dropped for good: istioctl, bash-completion and eksctl, along with the
  declined block itself. Everything it recorded has been settled
- corrected the iMazing app name, which upstream renamed. mas matches on the
  id, so this was cosmetic

- the dotfiles moved out to hansohn/dotfiles and are cloned by
  apps/dotfiles.sh rather than vendored in dotfiles/. Keeping two copies in
  step by hand is how the previous set drifted eight months out of date, and
  the configs are cross-platform, so they do not belong to a macOS setup
  script. The extracted repo covers more than the seven files here did --
  ghostty, k9s, bat, gh, ssh and terraform among them -- and its installer
  archives anything real it replaces
- apps/bash.sh, apps/vim.sh and apps/zsh.sh are gone. The dotfiles installer
  is passed --bootstrap, which fetches oh-my-zsh, vim-plug and the vim
  plugins those scripts handled, plus zsh-autosuggestions and
  zsh-syntax-highlighting -- both named in the shipped .zshrc but never
  installed by this repo
- .bash_profile is not carried over. It was 186 lines of Intel-era paths,
  anaconda, chefdk and dsc-cassandra, and was not installed on the machine
  it shipped from
- the neovim config is cloned straight to ~/.config/nvim. It used to be
  cloned into ~/.dotfiles and symlinked, to survive the rsync install.sh ran
  over that directory; that rsync is gone, and ~/.dotfiles is now the
  dotfiles checkout, so a clone inside it would leave an untracked directory
  in that repo. A pre-1.0 symlink is removed rather than followed
- bootstrap.sh is renamed to install.sh, with the old name left as a shim
  that warns and execs the new one. It will be removed after 1.0
- identity no longer ships in the repo. config.sh is gitignored and
  config.sh.example is the tracked template; install.sh refuses to run
  without config.sh rather than writing a placeholder identity onto the
  machine. preflight.sh and lib.sh come out of the installer into their own
  files
- the shared git configuration ships as a dotfile rather than being written
  once with `git config --global` behind a guard that could only ever fire on
  a fresh machine. Identity stays out of the tracked file, in
  ~/.gitconfig.local, pulled in with [include]
- ci runs on branches containing a slash. The push filter was '*', which
  does not match '/', so branches like chore/thing only ever got a run from
  the pull_request event

- repository renamed from osx-setup to mac-setup. GitHub keeps a redirect, so
  existing clones and links continue to work
- packages are declared in a Brewfile and installed with a single
  `brew bundle install`. bootstrap.sh drops from 214 lines to 97: the four
  package arrays and their four install loops are gone, along with the
  hand-written idempotency guards brew bundle makes unnecessary
- a Makefile exposes brew/install, brew/check, brew/drift and brew/dump.
  brew/drift lists packages installed but never declared, which is how the
  previous hand-maintained list fell years out of date
- .gitignore expanded from gitignore.io with the macos, linux, vim and
  visualstudiocode templates
- the neovim config moved out to hansohn/nvim and is cloned by apps/nvim.sh
  rather than vendored here. The copy in dotfiles/ was the bare LazyVim
  starter and had fallen behind; the repo carries a pinned lazy-lock.json, so
  a fresh clone reproduces a known-good setup and updates no longer need a
  change to this repo

APPLICATIONS ADDED:

- previously installed by apps/ scripts, now declared: bash, bash-completion,
  git, iterm2, macvim, openssl, packer, pyenv, pyenv-virtualenv, terraform,
  hashicorp-vagrant
- required by the dotfiles and neovim configs but never declared: ghostty,
  gcloud-cli, zulu@21, opencode, selene
- added during curation: 1password-cli, chatgpt, claude-code, eksctl,
  goimports, kubectx, maven, microsoft-teams, ollama, signal, speedtest,
  tfsec, uv, watch

APPLICATIONS REMOVED:

- brooklyn, tfswitch, font-iosevka-nerd-font, font-jetbrains-mono-nerd-font
  and yamlfmt. The fonts are unused -- ghostty asks only for Hack Nerd Font --
  and nothing references yamlfmt
- five apps/ scripts that only installed: openssl, packer, terraform, fonts
  and python

BUG FIXES:

- apps/iterm2.sh configured only on first install. Its shell integration and
  six colour schemes sat inside an `if ! brew ls iterm2` guard, so a re-run
  configured nothing
- bootstrap.sh ran the apps/ scripts before installing packages, which only
  worked while each script installed its own. Order is now homebrew, then
  brew bundle, then configuration
- two Packers were installed: apps/packer.sh used the core formula while the
  tap version was also present. HashiCorp moved Packer out of homebrew-core,
  so the tap is canonical
- docker, wireshark and virtualbox@beta were renamed upstream to
  docker-desktop, wireshark-app and virtualbox
- README named brew_formulae, brew_casks and mas_apps as the authoritative
  lists after they had been removed, still listed tfswitch, and described
  Claude Code as a desktop app when it is terminal-based

## [0.9.0](https://github.com/hansohn/osx-setup/compare/0.8.0..0.9.0) (Aug 16, 2026)

FEATURES:

- macOS defaults rewritten for macOS 26. Settings now address preference
  domains rather than plist file paths, which cfprefsd can overwrite
- firewall configured through socketfilterfw instead of the retired
  com.apple.alf domain
- battery percentage set via com.apple.controlcenter, the domain that replaced
  com.apple.menuextra.battery
- Dock, Finder and menu bar are restarted so settings apply without a logout
- nvm installed from homebrew
- renovate scoped to github-actions and moved to the repo root. It had been
  configured for terraform, which this repo contains none of, so it could
  never have matched anything

BUG FIXES:

- packer and vagrant no longer install packer-completion and
  vagrant-completion, both removed from homebrew-core
- apps/terraform.sh installs tflint as a cask; there is no tflint formula
- apps/terraform.sh matches installed formulae on the bare token, so
  tap-qualified names no longer reinstall on every run
- screenshot directory test used -f against a directory, so mkdir ran every
  invocation
- GitHub Actions pinned to releases; two tracked a moving branch
- shellcheck workflow now runs on pull requests, which pull_request nesting
  had prevented
- README tagline and description no longer pinned to the retired OSX name or
  to a single job title
- README prose unwrapped to one line per paragraph, matching the rest of the
  file
- licence copyright range extended to 2026

APPLICATIONS REMOVED:

- chefdk, docker, hadoop, java, nodejs, ruby and virtualbox helper scripts,
  none of which bootstrap.sh could reach. The docker and virtualbox casks
  already cover those two

## [0.8.0](https://github.com/hansohn/osx-setup/compare/0.7.0..0.8.0) (Aug 16, 2026)

First release since 0.7.0 in February 2019.

FEATURES:

- package lists consolidated into brew_formulae, brew_casks and mas_apps
- neovim replaces vim as the primary editor, with a LazyVim configuration
- tmux configuration added
- zshrc rewritten and resolves homebrew through BREW_PREFIX, so it works on
  Apple Silicon
- shellcheck GitHub Action added

APPLICATIONS ADDED:

- cloud and kubernetes: argocd, aws-vault, awscli, doctl, helm, istioctl,
  k9s, kind, kubernetes-cli, kustomize, session-manager-plugin
- infrastructure as code: ansible, ansible-lint, cfn-lint, terraform-docs,
  terraform-ls, terragrunt, tflint, tfswitch
- shell and editors: neovim, tmux, zsh, bat, fd, fzf, gh, lazygit, ripgrep,
  tree, tree-sitter
- languages: lua, luajit, luarocks
- linting: golangci-lint, jsonlint, shellcheck, yamllint
- utilities: gnupg, grep, ipcalc, mas, nmap
- applications: 1password, discord, obsidian, raycast, rectangle,
  visual-studio-code, zoom, font-hack-nerd-font
- mac app store: Amphetamine, Decompressor, iMazing HEIC Converter, Kindle

APPLICATIONS REMOVED:

- aerial, anaconda, apache-directory-studio, atom, brooklyn, caffeine,
  chefdk, dropbox, flux, hadoop, intellij-idea-ce, meld, pycharm-ce, sbt,
  spectacle, transmission

BUG FIXES:

- tflint declared as a formula, which no longer exists, aborting the install
- terminal colorscheme guard was a double negative and only applied the
  setting when it was already correct
- rust nightly toolchain unreachable through a dev/null typo
- oh-my-zsh never installed while zshrc was linked and sourced it
- neovim configuration copied but never symlinked, so it never loaded
- .tmux.conf entries created dangling symlinks
- install guards for tapped formulae, mas apps, fonts and vagrant could never
  match, so those packages reinstalled on every run
- homebrew installer appended to ~/.zprofile even when it was a symlink
- pubkey alias pointed at a key file that no longer exists

## [0.7.0](https://github.com/hansohn/osx-setup/compare/0.6.0..0.7.0) (Feb 20, 2019)

APPLICATIONS ADDED:

- [anaconda](https://www.anaconda.com/)
- [apache-directory-studio](https://directory.apache.org/studio/)
- [intellij-idea-ce](https://www.jetbrains.com/idea/)
- [pycharm-ce](https://www.jetbrains.com/pycharm/)
- [sbt](https://www.scala-sbt.org/)

## [0.6.0](https://github.com/hansohn/osx-setup/compare/0.5.3..0.6.0) (Sep 21, 2018)

APPLICATIONS ADDED:

- [dep](https://github.com/golang/dep)

APPLICATIONS REMOVED:

- [lastpass](https://www.lastpass.com/)
- [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)

BUG FIXES:

- fix brew taps
- fix brew chefdk install
- fix docker completions install 
- fix python install

KNOWN ISSUES:

- virtualbox will not install without user interaction due to kext issues

## [0.5.3](https://github.com/hansohn/osx-setup/compare/0.5.2..0.5.3) (Jan 31, 2018)

BUG FIXES:

- update readme application list

## [0.5.2](https://github.com/hansohn/osx-setup/compare/0.5.1..0.5.2) (Jan 31, 2018)

BUG FIXES:

- disable fast user switching
- disable show resent tags in finder
- fix java installation
- fix hadoop installation
- fix node installation
- fix nvm sourcing
- fix powerline fonts installation

KNOWN ISSUES:

- virtualbox will not install without user interaction due to kext issues

APPLICATIONS ADDED:

- [Go](https://golang.org/)
- [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)

## [0.5.1](https://github.com/hansohn/osx-setup/compare/0.5.0..0.5.1) (Jan 16, 2018)

BUG FIXES:

- fix atom installation
- fix docker installation
- fix hadoop installation
- fix nodejs installation
- fix packer installation
- fix python installation

APPLICATIONS ADDED:

- [meld](http://meldmerge.org/)

## [0.5.0](https://github.com/hansohn/osx-setup/compare/0.4.0..0.5.0) (Jan 15, 2018)

FEATURES:

- updated atom apm_packages list
- updated bash_profile
- updated vimrc
- updated vundle plugins
- add extension pack to virtualbox install

APPLICATIONS ADDED:

- [aerial](https://github.com/JohnCoates/Aerial)
- [caffeine](http://lightheadsw.com/caffeine/)
- [curl](https://curl.haxx.se/)
- [docker](https://www.docker.com/docker-mac)
- [hadoop](http://hadoop.apache.org/)
- [jq](https://stedolan.github.io/jq/)
- [postman](https://www.getpostman.com/)
- [spotify](https://www.spotify.com/us/)
- [slack](https://slack.com/)
- [wireshark](https://www.wireshark.org/)

APPLICATIONS REMOVED:

- [adobe flash](https://get.adobe.com/flashplayer/)
- [alfred](https://www.alfredapp.com/)
- [box sync](https://sites.box.com/sync4/)
- [htop](http://hisham.hm/htop/)
- [sbt](https://www.scala-sbt.org/)

## [0.4.0](https://github.com/hansohn/osx-setup/compare/0.3.1..0.4.0) (Feb 2, 2017)

FEATURES:

- add sbt to install list

BUG FIXES:

- fix changelog links

## [0.3.1](https://github.com/hansohn/osx-setup/compare/0.3.0..0.3.1) (Oct 25, 2016)

FEATURES:

- add vim pastetoggle vim functionality
- add bash pclip function

BUG FIXES:

- remove set paste functionality. its not working correctly

## [0.3.0](https://github.com/hansohn/osx-setup/compare/0.2.0..0.3.0) (Oct 24, 2016)

FEATURES:
- brew cask install alfred
- add salt, scala, and jinja functionality to vim
- update flushdns bash alias for el capitan and newer os versions

## [0.2.0](https://github.com/hansohn/osx-setup/compare/0.1.0..0.2.0) (Oct 22, 2016)

FEATURES:

- replace hyperdock with spectacle
- add tmux

## [0.1.0](https://github.com/hansohn/osx-setup/compare/0.0.3..0.1.0) (May 22, 2016)

FEATURES:

- add cluster ssh to install list
- add htop to install list
- add java jre to install list
- add nvm and nodejs stable to install list
- add python3 to install list
- remove vagrant box installations. this should be handled by vagrantfiles.

BUG FIXES:

- update brew-cask detection and installation
- fix powerline/fonts issue
- fix airline theme issue
- fix awscli installation
- fix gitconfig osxkeychain helper stanza 

## [0.0.3](https://github.com/hansohn/osx-setup/compare/0.0.2..0.0.3) (Jan 17, 2016)

FEATURES:

- added lots 3rd party desktop applications
- minor OSX config tweaks

## [0.0.2](https://github.com/hansohn/osx-setup/compare/0.0.1..0.0.2) (Jan 17, 2016)

FEATURES:

- add knife-ec2 gem to ruby gem list
- add 'fixbrew' alias to bash_profile
- add 'powerline font symbols to airline vimrc settings
- add additional vim bundles to plugins.vim

## [0.0.1](https://github.com/hansohn/osx-setup/compare/0.0.0..0.0.1) (Oct 18, 2015)

FEATURES:

- Create Changelog and start versioning releases
- Add export 'GOBIN="${GOPATH}/bin' to .bash_profile for GOLANG
- Add knife-acl to gem list in apps/ruby.sh script
- Rename bundle.vim to plugins.vim

BUG FIXES:

- Add wget prerequsite to apps/osx-terminal.sh script
