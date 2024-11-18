export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

 zstyle ':omz:update' mode reminder  # just remind me to update when it's time

 DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
#Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function form eat specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# plugins
plugins=(git zsh-autosuggestions)
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh


#OH MY ZSH
source $ZSH/oh-my-zsh.sh

#Alias'
alias ec-api='$HOME/.config/tmux/ec-api.sh'
alias strybttn-backend-run="RUST_LOG=debug cargo watch --workdir apps/bttn_plus_api --env-file=../../.env --ignore schema.graphql -- cargo run --bin bttn_plus_api"
alias strybttn-backend-test="RUST_LOG=debug cargo watch --workdir apps/bttn_plus_api --env-file=../../.env.test --ignore schema.graphql -- cargo test -- --nocapture --show-output"
alias strybttn-deps="dart run build_runner watch --delete-conflicting-outputs"

alias cargo='nocorrect cargo'

#Dump Environment Variables
function dump_env {
  local env_path="${1:-.env}"

  source $env_path && export $(sed '/^#/d' $env_path | cut -d= -f1)
}

#NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 

#Docker
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

#Flutter
export PATH="$HOME/flutter/bin:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
