# Declarative package list for macOS.
#
#   brew bundle install      install everything declared here
#   brew bundle check        report what is missing, install nothing
#   brew bundle cleanup      list installed packages NOT declared here
#   brew bundle dump --force regenerate this file from the current machine
#
# Configuration lives in hansohn/dotfiles, not here. This repo owns binaries;
# that one owns configs and works on Linux too.

#-------------------------------------------------------------------------------
# taps
#-------------------------------------------------------------------------------

tap "anomalyco/tap"
tap "hashicorp/tap"
tap "teamookla/speedtest"
tap "terraform-linters/tap"

#-------------------------------------------------------------------------------
# cli
#-------------------------------------------------------------------------------

brew "bat"
brew "curl"
brew "fd"
brew "fzf"
brew "gh"
brew "gnupg"
brew "grep"
brew "ipcalc"
brew "jq"
brew "mas"
brew "nmap"
brew "ripgrep"
brew "teamookla/speedtest/speedtest"
brew "tmux"
brew "tree"
brew "watch"
brew "wget"

#-------------------------------------------------------------------------------
# shell / editor
#-------------------------------------------------------------------------------

brew "bash"
brew "zsh"
brew "git"
brew "lazygit"
brew "neovim"
brew "macvim"
brew "tree-sitter"

#-------------------------------------------------------------------------------
# languages / runtimes
#-------------------------------------------------------------------------------

brew "go"
brew "golangci-lint"
brew "goimports"
brew "lua"
brew "luajit"
brew "luarocks"
brew "maven"
brew "nvm"                              # zsh/zshrc sources nvm.sh
brew "openssl"
brew "pyenv"                            # zsh/zshrc runs pyenv init
brew "pyenv-virtualenv"                 # zsh/zshrc runs pyenv virtualenv-init
brew "uv"

#-------------------------------------------------------------------------------
# cloud / kubernetes
#-------------------------------------------------------------------------------

brew "argocd"
brew "aws-vault"
brew "awscli"
brew "cfn-lint"
brew "helm"
brew "k9s"
brew "kind"
brew "kubectx"
brew "kubernetes-cli"
brew "kustomize"

#-------------------------------------------------------------------------------
# infrastructure as code
#-------------------------------------------------------------------------------

brew "ansible"
brew "ansible-lint"
brew "hashicorp/tap/terraform"
brew "terraform-docs"
brew "terraform-ls"
brew "terragrunt"
brew "tfsec"

#-------------------------------------------------------------------------------
# linting / formatting
#-------------------------------------------------------------------------------

brew "jsonlint"
brew "selene"
brew "shellcheck"
brew "stylua"
brew "yamllint"

#-------------------------------------------------------------------------------
# ai
#-------------------------------------------------------------------------------

brew "anomalyco/tap/opencode"           # opencode/ config is in dotfiles
brew "ollama"

#-------------------------------------------------------------------------------
# casks -- fonts
#-------------------------------------------------------------------------------

cask "font-hack-nerd-font"

#-------------------------------------------------------------------------------
# casks -- terminal / development
#-------------------------------------------------------------------------------

cask "1password-cli"
cask "claude-code@latest"
cask "docker-desktop"                   # renamed upstream from "docker"
cask "gcloud-cli"                       # zsh/zshrc sources path.zsh.inc
cask "hashicorp-vagrant"
cask "ghostty"                          # ghostty/config lives in dotfiles
cask "iterm2"
cask "postman"
cask "session-manager-plugin"
cask "terraform-linters/tap/tflint"     # no longer a formula; cask-only upstream
cask "virtualbox"                       # osx-setup declared @beta; plain is installed
cask "visual-studio-code"
cask "wireshark-app"                    # renamed upstream from "wireshark"
cask "zulu@21"                          # os/darwin.zsh derives JAVA_HOME from it

#-------------------------------------------------------------------------------
# casks -- applications
#-------------------------------------------------------------------------------

cask "1password"
cask "adobe-acrobat-reader"
cask "appcleaner"
cask "chatgpt"
cask "firefox"
cask "google-chrome"
cask "google-drive"
cask "microsoft-teams"
cask "obsidian"
cask "raycast"
cask "rectangle"
cask "slack"
cask "spotify"
cask "zoom"

#-------------------------------------------------------------------------------
# mac app store
#-------------------------------------------------------------------------------

mas "Amphetamine", id: 937984704
mas "Decompressor", id: 1033480833
mas "iMazing Converter", id: 1292198261

#-------------------------------------------------------------------------------
# declined
#-------------------------------------------------------------------------------
# Reviewed and deliberately not installed. Kept as a record so they are not
# rediscovered and re-litigated on the next pass.

# brew "yamlfmt"                        # nothing references it; yamllint covers linting
