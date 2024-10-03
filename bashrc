# Peter's bashrc
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

echo "started loading bashrc for interactive session"

if [[ $(hostname) == CSI* ]] ;
then
    eval $(ssh-agent -s)
    # ensure ssh always loads keys
    alias ssh='ssh-add -l || ssh-add && ssh'
fi

# HISTORY stuff
# append to the history file, don't overwrite it
shopt -s histappend

#use vim for systemd edits
export SYSTEMD_EDITOR="/bin/vim"

# use vim for editing
export EDITOR=/usr/bin/vim

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

export PROMPT_COMMAND="history -a; $PROMPT_COMMAND" # write to hist every time command is run
HISTTIMEFORMAT="%d/%m/%y %T "  # add timestamp to hist
export HISTSIZE=100000000000000000                   # big big history length
export HISTFILESIZE=100000000000000000               # big big history filesize

# Set a different History file for each system
mkdir -p "${HOME}/.bash_history.d/" # first make sure we have a bash history folder in this home dir
export HISTFILE="${HOME}/.bash_history.d/$(hostname)"
echo "your history will be saved to: $HISTFILE"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# unmount...
# https://unix.stackexchange.com/questions/9832/why-is-umount-not-spelled-unmount
alias unmount='umount'

# use "open" like macos:
alias open='xdg-open &>/dev/null'

# function to try and source if present 
tsource() {
    chmod +x $1 2>/dev/null
    if [ -x $1 ]; then  # if file executable
        source $1
        echo "sourced $1"
        return 0
    else
        return 1
    fi
}

# source bashrc specific to this site
tsource .site_bashrc

# source local bashrc
tsouce .bashrc.local

# Alias definitions.

# include an aliases file
if [ -f ~/.bash_aliases ]; then
    echo "loading ~/.bash_aliases"
    source ~/.bash_aliases
fi


# add some alias like HPE
alias +='pushd .'
alias -- -='popd'
alias ..='cd ..'
alias ...='cd ../..'
alias beep='echo -en "\007"'
alias cd..='cd ..'
alias dir='ls -l'
alias l='ls -alF'
alias la='ls -la'
alias ll='ls -l'
alias ls-l='ls -l'
alias md='mkdir -p'
alias mpirun='mpiexec'
alias o='less'
alias rd='rmdir'
alias rehash='hash -r'


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# (but it might not be)
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# load autocomplete
[ -r /usr/share/mm2/completions/mm2.bash ] && source /usr/share/mm2/completions/mm2.bash
# more completion
[ -r /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion
# load spack shell support
[ -r ~/dev/spack/share/spack/setup-env.sh ] && source ~/dev/spack/share/spack/setup-env.sh
[ -r ~/spack/share/spack/setup-env.sh ] && source ~/spack/share/spack/setup-env.sh
[ -r ~/.bin/spack/share/spack/setup-env.sh ] && source ~/.bin/spack/share/spack/setup-env.sh
[ -r ~/bin/spack/share/spack/setup-env.sh ] && source ~/bin/spack/share/spack/setup-env.sh

# try to install gitlab argcomplete
eval "$(register-python-argcomplete gitlab)"

# python venv
export VIRTUAL_ENV_DISABLE_PROMPT=1  # disable auto prompt change for venv

function virtualenv_info(){
    # Get Virtual Env
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Strip out the path and just leave the env name
        venv="${VIRTUAL_ENV##*/}"
    else
        # In case you don't have one activated
        venv=''
    fi
    [[ -n "$venv" ]] && echo "(venv:$venv)"
}

#VENV="\[\033[35m\]\$(virtualenv_info)\[\033[30m\]";

# disable the default virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1
# don't try and set venv in prompt if root
VENV='`[ $(id -u) == "0" ] && echo "" || echo "\[\033[35m\]\$(virtualenv_info)\[\033[30m\]"`'

#
# make sure things are in path
export PATH="~/.local/bin:$PATH"
export PATH="~/bin:$PATH"
export PATH="~/.bin:$PATH"
export PATH="~/Library/Python/3.9/bin:$PATH"

alias clip="echo \"no xclip or pbcopy command on this system\""
# easy clip per os
if command -v xclip; then
    alias clip='xclip -sel clip'
fi
if command -v pbcopy; then
    alias clip='pbcopy'
fi


# some ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias sl='ls'

# more nice aliases

alias home='cd'
alias documents='cd ~/Documents'
alias downloads='cd ~/Downloads'
alias pics='cd ~/Pictures'

alias c='clear'

# change Ansible stdout format for easier reading
export ANSIBLE_STDOUT_CALLBACK=debug


alias umosh="mosh --server=~/.bin/mosh-server"  # alias for non-root mosh

# shared host protections
if [[ $(w | cut -d ' ' -f 1 | sort -u | wc -l) -gt 3 ]]; then
    echo "there are currently multiple users on this system: "
    w | cut -d ' ' -f 1 | sort -u | grep -v USER | grep -v $USER
    echo
    echo "masking sudo and power commands"

    # power protections
    alias reboot="echo -e 'Is \033[1;31m$HOSTNAME\033[0m the correct hostname you want to restart?'"
    alias shutdown="echo -e 'Is \033[1;31m$HOSTNAME\033[0m the correct hostname you want to shutdown?'"
    alias sudo="echo -e 'Is \033[1;31m$HOSTNAME\033[0m the correct hostname you want to run this command on?'"
fi



# a status "icon" for use in prompt if desired
status='`if [ $? = 0 ]; then echo "\[\033[01;32m\]✔"; else echo "\[\033[01;31m\]✗"; fi`'"$normal"

export gitstat="" # start with empty git status
if which git; then  # if we have git installed
    # git status in prompt
    if ! tsource /usr/share/git-core/contrib/completion/git-prompt.sh ; then  # if cannot source global git bash prompt
        # if cannot source any git-prompt file
        if ! (
            tsource ~/.git-prompt.bash || 
            tsource ~/.config/git-prompt.sh || 
            tsource ~/git-prompt.sh ||
            tsource ~/.git-prompt.sh
            ); then
            echo "could not find git-prompt, download from internet"
            echo "curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > ~/.git-prompt.sh"
	    chmod +x ~/.git-prompt.sh
	    source ~/.git-prompt.sh
        fi
    fi
    # don't try to run the __git_ps1 if we are root
    gitstat='`[ $(id -u) == "0" ] && echo "" || echo "\[\033[32m\]$(__git_ps1 " (%s)")\[\033[00m\]"`'
    GIT_PS1_SHOWSTASHSTATE=true
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_SHOWDIRTYSTATE=true
    # setup git completion
    if ! tsource /usr/share/git-core/contrib/completion/git-completion.sh ; then # if cannot source global completion
        if ! (
            tsource ~/.git-completion.sh ||
            tsource ~/.git-completion.sh ||
            tsource ~/.config/git-completion.sh ||
            tsource ~/git-completion.sh ||
            tsource ~/.git-completion.bash ||
            tsource ~/git-completion.bash
            ); then
            echo "could not find git completion, download from internet"
            echo "curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.git-completion.bash"
	    chmod +x ~/.git-completion.bash
	    source ~/.git-completion.bash
        fi
    fi
    tsource ~/.git-completion.bash
    tsource ~/.git-prompt.sh
fi

# makes the bg color of the $user prompt portion red when prompt is run as root
user='`[ $(id -u) == "0" ] && echo "\[\e[0;41m\]\u\[\e[0;37m\]" || echo "\[\e[0;36m\]\u\[\e[0;00m\]"`'
# makes the color of the $term prompt portion red when prompt is run as root
term='`[ $(id -u) == "0" ] && echo "\[\e[0;31m\]\$\[\e[0;37m\]" || echo "\[\e[0;36m\]\$\[\e[0;00m\]"`'

function whoisport() {
port=$1
pidInfo=$(fuser $port/tcp 2> /dev/null)
pid=$(echo $pidInfo | cut -d':' -f2)
ls -l /proc/$pid/exe
}

# have ssh automaticaly cd into the dir we are in on the remote machine
sshcd() {
ssh -t "$@" "cd '$(pwd)'; bash -l";
}



# vi prompt
set -o vi
set editing-mode vi
set show-mode-in-prompt on   # only works in bash >4.3
set vi-ins-mode-string "\[\033[32m\]+\[\033[00m\]"
set vi-cmd-mode-string "\[\033[34m\]:\[\033[00m\]"
export PS1="🔚  exit $?, \j jobs \n\s \v $user@\[\033[33m\]\H\[\033[00m\]:\w$gitstat${VENV}$term "
echo "loaded bashrc"
echo 
echo -e "$(tput bold)system info:$(tput sgr0)"
uname -a
echo 
case "$(uname -s)" in
    Linux*)
        cat /etc/*release* | head -n 2
        echo 
        echo "$(nproc --all) cores"
        free -h
        echo 
        df -h ~ | tail -n 1
        df -h / | tail -n 1
        echo
        ip -4 -brief a 
        ;;
    Darwin*)
        system_profiler SPSoftwareDataType SPHardwareDataType
        ;;
esac

echo

bash --version | head -n 1 


unset PROMPT_COMMAND # maybe 
