# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/d/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/Users/d/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/d/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/d/.fzf/shell/key-bindings.zsh"
