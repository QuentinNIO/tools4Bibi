#cd#!/usr/bin/zsh
export PATH='/usr/bin:/bin:/usr/sbin:/usr/local/bin:/sbin'
# For our compilation scripts
mkdir -p $HOME/work
export GIT_PATH=$HOME/work

# Correct some locales problems
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export VERSION_NAME=9.9.9
export BUILD_NUMBER=999
#export PATH=$PATH:/usr/local/share/npm/bin
#export PATH=$PATH:/opt/X11/bin

# SSH_ParisOffice


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
alias addAndroidHOME='export ANDROID_HOME=$HOME/Library/Android/sdk'
alias addAndroidNDK='export ANDROID_NDK=$HOME/Library/Android/sdk/ndk-bundle'
alias ourIP='curl ipecho.net/plain'

myIP(){
    ifconfig | grep -A4 'en0' | grep 'inet ' | cut -d ' ' -f2
}

initAndroid(){
    addAndroidHOME
    addAndroidNDK
    export PATH=$PATH:$ANDROID_HOME/platform-tools:/Library/Frameworks/Python.framework/Versions/3.6/bin
    export ardkKeyPassword=$1
    export ardkStorePassword=$1
}

initRspec(){
    if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
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
    tailA    = tail -n+1
    zshconf   = move zshrc old_zshrc.sh -> cp zshrc.sh $HOME/.zshrc
    addAndroidHOME
    initAndroid "<common_password>"
    openA <file>
    myIP
    ourIP
----------------------------------
EOF
}

# find in files
# arg1: path to search
# arg2: file extension
# arg3: text to find
search_in() {
 dir=$1;
 shift; 
 ext=$1;
 shift;
 text=$*;
 find $dir -iname "*\.$ext" | xargs grep "$text" -sl;
}

# find in all files
# arg1: path to search
# arg2: text to find
search_all() {
 dir=$1;
 shift; 
 text=$*;
 find $dir | xargs grep "$text" -sl;
}


# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)



#######
# ENV #
#######

if [[ $- != *i* ]]; then
	# Shell is non-interactive.  Be done now
	return
fi


#if ! echo "$PATH" | grep -q ~/bin; then
#  export PATH=~/bin:"${PATH}"
#fi
export EDITOR='emacs'
export MAIL="/var/mail/$USER"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.rar=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
export LS_OPTIONS='-F'
export NO_STRICT_EPITA_HEADERS='1' # Used for ViM


#[ ! -z "$DISPLAY" ] && xset b off &> /dev/null && xset r rate 250 75

###########
# ALIASES #
###########

lsbin='ls'
if [ "`uname -s | sed 's/^.*BSD$/BSD/'`" = 'BSD' ] || [ "`uname -s`" = 'Darwin' ]; then
  gls >/dev/null 2>/dev/null && lsbin='gls' && \
    export LS_OPTIONS="$LS_OPTIONS -b -h --color"
elif [ "`uname -s`" = "Linux" ]; then
  export LS_OPTIONS="$LS_OPTIONS -b -h --color"
fi;
alias l="$lsbin $LS_OPTIONS"
alias ls="$lsbin $LS_OPTIONS"
alias ll="$lsbin $LS_OPTIONS -l"
alias la="$lsbin $LS_OPTIONS -la"
alias lr="$lsbin $LS_OPTIONS -laR"


if [ "`uname -s`" != "SunOS" ]; then
#  alias rm="rm -v"
  if gmv --version >/dev/null 2>/dev/null; then
    alias mv="gmv -v"
  else
    alias mv="mv -v"
  fi
  if gcp --version >/dev/null 2>/dev/null; then
    alias cp="gcp -v"
  else
    alias cp="cp -v"
  fi
fi;
if grm --version >/dev/null 2>/dev/null; then
  alias rrm="grm -v"
else
  alias rrm="/bin/rm -v"
fi
alias rm="rm -i"
test -x ~/bin/rm.sh && alias rm="$HOME/bin/rm.sh"
alias web="firefox &!"
alias gh="echo 'corrected gh to fg'; fg"

for app in svn prcs cvs; do
  type vcs-$app | grep -qF 'is /' && alias $app="vcs-$app"
done




#e() { gnuclient $* & }

#em() { emacs "$@" &}
#xem() { xemacs "$@" &}
lm() { ls -la "$@" | more}
mkcd()
{
  test $# -gt 0 || {
    echo 'Usage: mkcd [args] dir (see man mkdir)' >&2
    return 1
  }
  local i=0
  local dir='' # last argument = target directory
  while [ $i -lt $# ]; do
    dir="$1"
    shift
    set dummy "$@" "$dir"
    shift
    i=$((i+1))
  done
  test -d "$dir" || mkdir "$@"
  test -d "$dir" || {
    echo "mkcd: Cannot create directory $dir"
    return 1
  }
  cd "$dir"
}

###############
# ZSH OPTIONS #
###############

setopt correct                  # spelling correction
setopt complete_in_word         # not just at the end
setopt alwaystoend              # when completing within a word, move cursor to the end of the word
setopt auto_cd                  # change to dirs without cd
setopt hist_ignore_all_dups     # If a new command added to the history list duplicates an older one, the older is removed from the list
setopt hist_find_no_dups        # do not display duplicates when searching for history entries
setopt auto_list                # Automatically list choices on an ambiguous completion.
setopt auto_param_keys          # Automatically remove undesirable characters added after auto completions when necessary
setopt auto_param_slash         # Add slashes at the end of auto completed dir names
#setopt no_bg_nice               # ??
setopt complete_aliases
setopt equals                   # If a word begins with an unquoted `=', the remainder of the word is taken as the name of a command.
                                # If a command exists by that name, the word is replaced by the full pathname of the command.
setopt extended_glob            # activates: ^x         Matches anything except the pattern x.
                                #            x~y        Match anything that matches the pattern x but does not match y.
                                #            x#         Matches zero or more occurrences of the pattern x.
                                #            x##        Matches one or more occurrences of the pattern x.
setopt hash_cmds                # Note the location of each command the first time it is executed in order to avoid search during subsequent invocations
setopt hash_dirs                # Whenever a command name is hashed, hash the directory containing it
setopt mail_warning             # Print a warning message if a mail file has been accessed since the shell last checked.
setopt append_history           # append history list to the history file (important for multiple parallel zsh sessions!)
#setopt share_history            # imports new commands from the history file, causes your typed commands to be appended to the history file

#autoload mere zed
#autoload zfinit

HISTFILE=~/.history_zsh
SAVEHIST=1942
HISTSIZE=1942

LOGCHECK=60
WATCHFMT="%n has %a %l from %M"
WATCH=all

fpath=(~/.zsh/functions $fpath)

##########
# COLORS #
##########

std="%{[m%}"
red="%{[0;31m%}"
green="%{[0;32m%}"
yellow="%{[0;33m%}"
blue="%{[0;34m%}"
purple="%{[0;35m%}"
cyan="%{[0;36m%}"
grey="%{[0;37m%}"
white="%{[0;38m%}"
lred="%{[1;31m%}"
lgreen="%{[1;32m%}"
lyellow="%{[1;33m%}"
lblue="%{[1;34m%}"
lpurple="%{[1;35m%}"
lcyan="%{[1;36m%}"
lgrey="%{[1;37m%}"
lwhite="%{[1;38m%}"

###########
# PROMPTS #
###########

# Initialize colors.
autoload -U colors
colors
 
# Allow for functions in the prompt.
setopt PROMPT_SUBST
 
# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
 
# Enable auto-execution of functions.
typeset -ga precmd_functions

# Append git functions needed for prompt.
precmd_functions+='update_current_git_vars'


PS2='`%_> '       # secondary prompt, printed when the shell needs more information to complete a command.
PS3='?# '         # selection prompt used within a select loop.
PS4='+%N:%i:%_> ' # the execution trace prompt (setopt xtrace). default: '+%N:%i>'


local rbenvprompt_user="${lred}%n${std}"
local prompt_host="${lred}%m ${std}"
local prompt_cwd="%B%40<..<%~%<<%b"
local prompt_time="${lblue}%D{%H:%M}${std}"
local prompt_rv="%(?..${lred}%?${std} )"

#PROMPT='${prompt_host}:${lgreen}${prompt_cwd}$(prompt_git_info)${lblue}%(!.#.$) '
PROMPT=${prompt_host}$'%{${fg[cyan]}%}%B%~%b$(prompt_git_info)%{${fg[default]}%} '


#PROMPT="${lgreen}${prompt_cwd}${lblue}%(!.#.$) "
RPROMPT="${prompt_rv}${prompt_time}"


##############
# TERM STUFF #
##############

#/bin/stty erase "^H" intr "^C" susp "^Z" dsusp "^Y" stop "^S" start "^Q" kill "^U"  >& /dev/null

chpwd() {
    [[ -t 1 ]] || return
    case $TERM in
      sun-cmd) print -Pn "\e]l%n@%m %~\e\\"
        ;;
      *xterm*|rxvt|(k|E|dt)term) print -Pn "\e]0;%n@%m %~\a"
        ;;
    esac
}

chpwd

#setterm -blength 0

################
# KEY BINDINGS #
################

bindkey -e
#bindkey -v
bindkey '\e[1~'	beginning-of-line	# home
bindkey '\e[4~'	end-of-line		# end
bindkey "^[[A"	up-line-or-search	# cursor up
#bindkey -s '^P'	"|less\n"		# ctrl-P pipes to less
#bindkey -s '^B'	" &\n"			# ctrl-B runs it in the background
bindkey "\eOP"	run-help		# run-help when F1 is pressed
bindkey ' '	magic-space		# also do history expansion on space
type run-help | grep -q 'is an alias' && unalias run-help

#######################
# COMPLETION TWEAKING #
#######################

# The following lines were added by compinstall
_compdir=~/usr/share/zsh/functions
[[ -z $fpath[(r)$_compdir] ]] && fpath=($fpath $_compdir)

autoload -U compinit; compinit
#compinit /home/prolob/pollux/.zcompdump # wtf?

# This one is a bit ugly. You may want to use only `*:correct'
# if you also have the `correctword_*' or `approximate_*' keys.
# End of lines added by compinstall

zmodload zsh/complist

zstyle ':completion:*:processes' command 'ps -au$USER'     # on processes completion complete all user processes
zstyle ':completion:*:descriptions' format \
       $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'           # format on completion
zstyle ':completion:*' verbose yes                         # provide verbose completion information
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format \
       $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
zstyle ':completion:*:matches' group 'yes'                 # separate matches into groups
zstyle ':completion:*:options' description 'yes'           # describe options in full
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:*:zcompile:*' ignored-patterns '(*~|*.zwc)'

# activate color-completion(!)
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

## correction

# Ignore completion functions for commands you don't have:
#  zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

zstyle ':completion:*'             completer _complete _correct _approximate
zstyle ':completion:*:correct:*'   insert-unambiguous true
#  zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
#  zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%}'
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'   original true
zstyle ':completion:correct:'      prompt 'correct to:'

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:' max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'
#  zstyle ':completion:*:correct:*'   max-errors 2 numeric

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# ignore duplicate entries
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# filename suffixes to ignore during completion (except after rm command)
#  zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns  '*?.(o|c~|old|pro|zwc)' '*~'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# If there are more than N options, allow selecting from a menu with
# arrows (case insensitive completion!).
#  zstyle ':completion:*-case' menu select=5
zstyle ':completion:*' menu select=2

# zstyle ':completion:*:*:kill:*' verbose no
#  zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
#                                /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# caching
[ -d $ZSHDIR/cache ] && zstyle ':completion:*' use-cache yes && \
                        zstyle ':completion::complete:*' cache-path $ZSHDIR/cache/

# use ~/.ssh/known_hosts for completion
#  local _myhosts
#  _myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
#  zstyle ':completion:*' hosts $_myhosts
known_hosts=''
[ -f "$HOME/.ssh/known_hosts" ] && \
known_hosts="`awk '$1!~/\|/{print $1}' $HOME/.ssh/known_hosts | cut -f1 -d, | xargs`"


zstyle ':completion:*:hosts' hosts ${=lrde_hosts} ${=known_hosts}

# simple completion for fbset (switch resolution on console)
_fbmodes() { compadd 640x480-60 640x480-72 640x480-75 640x480-90 640x480-100 768x576-75 800x600-48-lace 800x600-56 800x600-60 800x600-70 800x600-72 800x600-75 800x600-90 800x600-100 1024x768-43-lace 1024x768-60 1024x768-70 1024x768-72 1024x768-75 1024x768-90 1024x768-100 1152x864-43-lace 1152x864-47-lace 1152x864-60 1152x864-70 1152x864-75 1152x864-80 1280x960-75-8 1280x960-75 1280x960-75-32 1280x1024-43-lace 1280x1024-47-lace 1280x1024-60 1280x1024-70 1280x1024-74 1280x1024-75 1600x1200-60 1600x1200-66 1600x1200-76 }
compdef _fbmodes fbset

# use generic completion system for programs not yet defined:
compdef _gnu_generic tail head feh cp mv gpg df stow uname ipacsum fetchipac

# Debian specific stuff
# zstyle ':completion:*:*:lintian:*' file-patterns '*.deb'
zstyle ':completion:*:*:linda:*'   file-patterns '*.deb'

_debian_rules() { words=(make -f debian/rules) _make }
compdef _debian_rules debian/rules # type debian/rules <TAB> inside a source package

# see upgrade function in this file
compdef _hosts upgrade

###############
# MISC. STUFF #
###############

[ -r ~/.zshrc.local ] && source ~/.zshrc.local

[ -r /nix/etc/profile.d/nix.sh ] && source /nix/etc/profile.d/nix.sh
umask 0066

function gpge {
    if [ $# != 1 ]; then
	echo "usage: gpge <file>"
    else
	gpg -o $1.gpg -r $EMAIL -e $1 && rm -f $1
    fi
}

function gpgd {
    if [ $# != 1 ]; then
	echo "usage: gpgd <file.gpg>"
    else
	gpg  -o `basename $1 .gpg` -d $1
    fi
}

function gpgcat {
    if [ $# != 1 ]; then
	echo "usage: gpgcat <file.gpg>"
    else
	file=`basename $1 .gpg`
	gpg  -o $file -d $1 && cat $file && rm -f $file
    fi
}

#######IFS#######
IFS_TRUNK="${GIT_PATH}/repo/ifsrepo"
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

alias e="emacs -nw"
alias ne="emacs -nw"
cd $HOME
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

cd ${GIT_PATH}
export PATH="$PATH:/usr/local/opt/imagemagick@6/bin"

echo "IP Local $(myIP)"
