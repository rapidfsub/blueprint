#!/bin/bash

set -e

if [[ $(arch) != "arm64" ]]; then
  true
elif pgrep oahd &>/dev/null; then
  true
else
  softwareupdate --install-rosetta --agree-to-license
fi

sudo -v
if ! command -v nix &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

sudo -v
nix run nix-darwin -- switch --flake .#simple

sudo -v
if ! command -v brew &>/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

zsh -c '
  task chezmoi:apply
  . ~/.zprofile
  task brew:bundle
  task vscode:sync-extensions'
