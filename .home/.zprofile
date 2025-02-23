eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"

export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
# eval "$(vfox activate zsh)"

export PATH="/Applications/Postgres.app/Contents/Versions/16/bin:$PATH"

function c {
  pushd . &>/dev/null
  z $1 &>/dev/null
  code $(ls | grep -m 1 .code-workspace || echo ".")
  popd &>/dev/null
}
