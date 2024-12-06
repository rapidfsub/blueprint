#!/bin/zsh

set -e

. /etc/zshenv
task chezmoi:apply

. ~/.zprofile
task brew:bundle
task vscode:sync-extensions
