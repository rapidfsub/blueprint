#!/bin/zsh

set -e

. /etc/zshenv
task chezmoi:apply

. ~/.zprofile
task brew:bundle
task vscode:sync
task yes24:download
