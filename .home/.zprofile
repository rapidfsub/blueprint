eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(direnv hook zsh)"
. $(brew --prefix asdf)/libexec/asdf.sh
# eval "$(vfox activate zsh)"
eval "$(zoxide init zsh)"

export PATH="/Applications/Postgres.app/Contents/Versions/16/bin:$PATH"

function c {
  pushd . &>/dev/null
  z $1 &>/dev/null
  code $(ls | grep -m 1 .code-workspace || echo ".")
  popd &>/dev/null
}
