
# Set correct shell
export SHELL="/usr/bin/zsh"

# Starship configuration
export STARSHIP_CONFIG="$HOME/.dots/starship/zsh.toml"

# Specify the history file
export HISTFILE=$HOME/.zsh_hist

# Specify history-related opts
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_VERIFY

# zsh-related opts
setopt AUTO_CD
setopt CDABLE_VARS
setopt NO_BG_NICE
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

# User overrides
export OVERRIDE_FILE="$HOME/.env"
