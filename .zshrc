# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
#
# new machine:
# defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
# defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

export ZSH="/Users/derekdai/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
export PATH="$PATH:$HOME/.rvm/bin"

ZSH_THEME=""
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
plugins=(git)

#_______GIT COLOR_________
# source ~/git-completion.bash
# fpath=($fpath)
# script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit

# OLD BASH STUFF
# reset_color="\033[0m"
# git_clean_color="\033[0;32m"
# git_dirty_color="\033[0;31m"
# parse_git_branch() {
#     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
# }
# parse_color() {
#     if ! git rev-parse --git-dir > /dev/null 2>&1; then
#         return 0
#     fi
#     git_color=${reset_color}
# # git diff-index --quiet
#     if [ -z "$(git status --untracked-files=no --porcelain)" ];
#     # if [[ -z $(git status -s) ]];
#     then
#         git_color=${git_clean_color}
#     else
#         git_color=${git_dirty_color}
#     fi
#     echo -e $git_color
# }
# export PS1="\[\$(parse_color)\]\$(parse_git_branch)\[\e[0m\] \W \$ "
# setopt PROMPT_SUBST
# autoload -U colors && colors
# export PS1="\$(parse_color)\$(parse_git_branch) $fg[white]%1d \$ "

autoload -U promptinit; promptinit
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
prompt pure

#_______GIT STUFF_________
alias g='git'
alias gi='git init'
alias gs='git status'
alias gb='git branch'
alias ga='git add'
alias gc='git commit -m'
alias gp='git pull'
alias gco='git checkout'
alias gcom='git checkout master'
alias gcob='git checkout -b'
alias gm='git merge'
alias gst='git stash'
alias gsp='git stash pop'
alias gl='git log'
alias gd='git diff'
alias gf='git checkout `git branch --format="%(refname:short)" | fzf`'
alias gdel='git branch -d'
alias gpom='git pull origin master'

function gac() {
    git add .
    git commit -a -m "$1"
}
function gacp() {
    git add .
    git commit -a -m "$1"
    git push
}
function changed() {
  vim -O $(git status --porcelain | awk '{print $2}')
}
# leftover from vscode
#function changes() {
    #code `git changed`
    ## default input to current branch + master
    #for i in $(git changed)
    #do
        #code $i
    #done
    #echo $arr
#}
function gfind() {
    declare -a arr
    phrase=""
    for word in "$@"
    do
        phrase+="$word"
        phrase+="-"
    done

    for i in `git branch -l | grep "${phrase%?}"`

    do
        arr+=("$i")
        # echo $i
    done
    # echo $arr
    for i in ${!arr[@]};
    do
        echo $i: ${arr[$i]}
    done

    read index
    git checkout ${arr["$index"]}

    # echo each element w/ index
    # read number
    # git checkout array[number]
    # return matching branches and number them to select from
}



#___________GENERAL__________
alias ..='cd ..'
alias c=code
alias v=vim
# alias q='fc -s'
alias q=r
alias nah="git reset --hard"
alias stats="watch -n1 istats --no-graphs"
# set -o vi
set editing-mode v

alias sz='source $HOME/.zshrc'
alias ve='v $HOME/.vimrc'
alias ze='v $HOME/.zshrc'
alias te='v $HOME/.tc_settings'

alias ctags="`brew --prefix`/bin/ctags"
alias t='vim -t "$(cut -f1 tags | tail +7 | uniq | fzf)"'
alias tags="ctags -R --exclude=node_modules --exclude=public --exclude=vendor --exclude=db --exclude=tmp"


# fh - repeat history
qq() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
}

regex () {
	gawk 'match($0,/'$1'/, ary) {print ary['${2:-'0'}']}'
}

#git shortcuts
function git_repo() {
  if [ ! -d .git ] ;
    then echo "ERROR: This isnt a git directory" && return false;
  fi

  git config --get remote.origin.url | regex "\/(.*)\.git" 1
}



function fd() {
    if [[ "$#" != 0 ]]; then
        builtin fd "$@";
        return
    fi
    while true; do
        local lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --preview '
                __fd_nxt="$(echo {})";
                __fd_path="$(echo $(pwd)/${__fd_nxt} | sed "s;//;/;")";
                echo $__fd_path;
                echo;
                ls -p "${__fd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin fd "$dir" &> /dev/null
    done
}
export FZF_DEFAULT_OPTS="--bind tab:up,shift-tab:down"

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='Rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git}"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='--height 96% --reverse --preview "cat {}"'
fi


alias vf='vim "$(fzf)"'

eval "$(rbenv init -)"


# reset file path from git head
function reset() {
  git checkout head -- "$1"
}

# kill ruby rails server
function kill() {
  kill -9 $(lsof -i tcp:3000 -t)
}

source ~/.tc_settings

# add ripgrep
