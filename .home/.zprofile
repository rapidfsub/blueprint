eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(direnv hook zsh)"
eval "$(vfox activate zsh)"
eval "$(zoxide init zsh)"

export PATH="/Applications/Postgres.app/Contents/Versions/16/bin:$PATH"

function c {
  pushd . &>/dev/null
  z $1 &>/dev/null
  code .
  popd &>/dev/null
}
