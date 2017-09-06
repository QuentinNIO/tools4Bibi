#cd#!/usr/bin/zsh
export PATH='/usr/bin:/bin:/usr/sbin:/usr/local/bin:/sbin'
# For our compilation scripts
mkdir -p $HOME/work
export GIT_PATH=$HOME/work


#Brackets
alias Brackets='open -a /Applications/Brackets.app'
alias Brackets2='open -a /Applications/Brackets_2.app'
alias Brackets3='open -a /Applications/Brackets_3.app'

# Git
alias gits='git status'
alias gitd='git diff'
alias gita='git add'
alias gitt='git lfs track'
alias gitr='cd $(git rev-parse --show-cdup)'
alias tailA='tail -n+1'
alias zshconf='mv $HOME/.zshrc $HOME/old_zshrc.sh && cp zshrc.sh $HOME/.zshrc'
alias bashconf='mv $HOME/.bashrc $HOME/old_bashrc.sh && cp bashrc.sh $HOME/.bashrc'


myIP(){
    ifconfig | grep -A4 'en0' | grep 'inet ' | cut -d ' ' -f2
}

openA (){
    open -a /Applications/Brackets.app $1
}

help() {
cat << EOF
-------------- Help --------------

SSH :
    
IDE :
    Brackets  -  Brackets2  - Brackets3

GIT : 
    gits      = git status
    gitd      = git diff
    gita      = git add
    gitt      = git lfs track
    gitr      = cd directly to git root dir
    
OTHERS :
    tailA     = tail -n+1
    zshconf   = move zshrc old_zshrc.sh -> cp zshrc.sh $HOME/.zshrc
    bashconf  = same as zshconf
    openA <file>
    myIP
    ourIP
----------------------------------
EOF
}

promptGitInfo(){
    unset __CURRENT_GIT_BRANCH
    unset __CURRENT_GIT_BRANCH_STATUS
    unset __CURRENT_GIT_BRANCH_IS_DIRTY

    local st="$(git status 2>/dev/null)"
    if [[ -n "$st" ]]; then
        if [ "$( echo $st | cut -d ' ' -f2)" == 'branch' ]; then
            __CURRENT_GIT_BRANCH="$( echo $st | cut -d ' ' -f3)"
        else    
            __CURRENT_GIT_BRANCH="unknown"
        fi
        
        local branchSt="$(echo $st | cut -d ' ' -f7)"
        if [ "$branchSt" == 'ahead' ]; then
            __CURRENT_GIT_BRANCH_STATUS="ahead"
        elif [ "$branchSt" == 'diverged' ]; then
            __CURRENT_GIT_BRANCH_STATUS="diverged"
        elif [ "$branchSt" == 'up-to-date' ]; then
            __CURRENT_GIT_BRANCH_STATUS="up-to-date"
        else    
            __CURRENT_GIT_BRANCH_STATUS="unknown"
        fi
        

        if [ "$(echo ${st} | grep 'nothing to commit')" = "" ]; then
            __CURRENT_GIT_BRANCH_IS_DIRTY='1'
        fi
    fi
    
    
    
    if [ -n "$__CURRENT_GIT_BRANCH" ]; then
        local s="("
        s+="$__CURRENT_GIT_BRANCH"
        case "$__CURRENT_GIT_BRANCH_STATUS" in
            ahead)
            s+="↑"
            ;;
            diverged)
            s+="↕"
            ;;
            behind)
            s+="↓"
            ;;
        esac
        if [ -n "$__CURRENT_GIT_BRANCH_IS_DIRTY" ]; then
            s+="⚡"
        fi
        s+=")"

        printf "$s"
    fi
}

PS1='\[\033[35;1m\]\h\[\033[0m\] \[\033[36;1m\]${PWD/#$HOME/'~'}\[\033[0m\] \[\033[33;1m\]$(promptGitInfo)\[\033[0m\] '
