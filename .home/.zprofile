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

function mix_env {
  echo "MIX_ENV=$MIX_ENV"
}

alias emd="export MIX_ENV=dev; mix_env"
alias emt="export MIX_ENV=test; mix_env"
