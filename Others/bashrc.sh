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
alias fsize='du -hs'
alias ourIP='curl ipecho.net/plain'
alias ifsEnv='ifs'


alias la='ls -la'

sizeOfFiles(){
    find . -type f -name "*.$1" -exec du -ch {} + | grep total$
}

findInFiles(){
    if [ "$1" == '-h' ]; then
        echo "grep -rnw . -e \$1 --include=\*.\$2"
    else
        grep -rnw . -e $1 --include=\*.$2
    fi
    
    #    --exclude-dir={dir1,dir2,*.dst}
    #    --exclude, --include, --exclude-dir or --include-dir
}

findFiles(){
    if [ "$1" == '-h' ]; then
        echo "find \$1 -type f -name *.\$2"
    else
        find $1 -type f -name "*.$2"
    fi
    
}



fcount(){
    for var in "$@"
    do
        echo " $var ->"$(find $var -type f | wc -l)
    done
    
}

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
    gits        = git status
    gitd        = git diff
    gita        = git add
    gitt        = git lfs track
    gitr        = cd directly to git root dir

FILES & FOLDERS : 
    fsize       = <fsize> <fsize *> <fsize 'foldername'> 
    fcount      = <fcount .> <fcount *> <fcount 'foldername'>
    findFiles   = <findFiles . 'extension'>
    findInFiles = <findInFiles 'patternToFind' 'extensionFiles'>
    sizeOfFiles = <sizeOfFiles 'extensionFiles'>
    

OTHERS :
    tailA       = tail -n+1
    zshconf     = move zshrc old_zshrc.sh -> cp zshrc.sh $HOME/.zshrc
    bashconf    = same as zshconf
    openA <file>
    myIP
    ourIP
    ifsEnv      = load ifs Env
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

#######IFS#######
IFS_TRUNK="${GIT_PATH}/repo/ifsrepo"
#current ifeelsmart repository used
alias cdtrunk="cd ${IFS_TRUNK}"


ifs()
{
	if [ -f ${IFS_TRUNK}/Script/ifs.env ]; then
		cd ${IFS_TRUNK}
		  source Script/ifs.env
		cd -
	else
		echo "${IFS_TRUNK}/Script/ifs.env not found : cannot load ifs environment"
	fi
}
export PATH="$PATH:Script:Helper"

###################

PS1='\[\033[31;1m\]${?/0/''}\[\033[0m\]\[\033[35;1m\]>\h\[\033[0m\]:\[\033[36;1m\]${PWD/#$HOME/'~'}\[\033[0m\]\[\033[33;1m\]$(promptGitInfo)\[\033[0m\]\[\033[37;1m\] \$\[\033[0m\] '
