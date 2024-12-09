eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(direnv hook zsh)"
eval "$(vfox activate zsh)"
eval "$(zoxide init zsh)"

function c {
  pushd . &>/dev/null
  z $1 &>/dev/null
  code .
  popd &>/dev/null
}
