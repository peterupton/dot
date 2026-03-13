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

# use "open" like macos if we are in Linux
case "$(uname -s)" in
    Linux*)
        alias open='xdg-open &>/dev/null'
esac

# function to try and source if present 
tsource() {
    chmod +x $1 2>/dev/null
    if [ -x $1 ]; then  # if file executable
        source $1
        echo "sourced $1"
        return 0
    else
	echo "could not source $1"
        return 1
    fi
}


get ssh fingerprints
function fingerprints() {
  local file="${1:-$HOME/.ssh/authorized_keys}"
  while read l; do
    [[ -n $l && ${l###} = $l ]] && ssh-keygen -l -f /dev/stdin <<<$l
  done < "${file}"
}

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

# don't try and set venv in prompt if root
VENV='`[ $(id -u) == "0" ] && echo "" || echo "\[\033[35m\]\$(virtualenv_info)\[\033[30m\]"`'

#
# make sure things are in path
export PATH="~/.local/bin:$PATH"
export PATH="~/bin:$PATH"
export PATH="~/.bin:$PATH"
export PATH="~/Library/Python/3.9/bin:$PATH"
export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:/opt/homebrew/sbin"

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



# bash completion V2 for glab                                 -*- shell-script -*-

__glab_debug()
{
    if [[ -n ${BASH_COMP_DEBUG_FILE-} ]]; then
        echo "$*" >> "${BASH_COMP_DEBUG_FILE}"
    fi
}

# Macs have bash3 for which the bash-completion package doesn't include
# _init_completion. This is a minimal version of that function.
__glab_init_completion()
{
    COMPREPLY=()
    _get_comp_words_by_ref "$@" cur prev words cword
}

# This function calls the glab program to obtain the completion
# results and the directive.  It fills the 'out' and 'directive' vars.
__glab_get_completion_results() {
    local requestComp lastParam lastChar args

    # Prepare the command to request completions for the program.
    # Calling ${words[0]} instead of directly glab allows handling aliases
    args=("${words[@]:1}")
    requestComp="${words[0]} __complete ${args[*]}"

    lastParam=${words[$((${#words[@]}-1))]}
    lastChar=${lastParam:$((${#lastParam}-1)):1}
    __glab_debug "lastParam ${lastParam}, lastChar ${lastChar}"

    if [[ -z ${cur} && ${lastChar} != = ]]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go method.
        __glab_debug "Adding extra empty parameter"
        requestComp="${requestComp} ''"
    fi

    # When completing a flag with an = (e.g., glab -n=<TAB>)
    # bash focuses on the part after the =, so we need to remove
    # the flag part from $cur
    if [[ ${cur} == -*=* ]]; then
        cur="${cur#*=}"
    fi

    __glab_debug "Calling ${requestComp}"
    # Use eval to handle any environment variables and such
    out=$(eval "${requestComp}" 2>/dev/null)

    # Extract the directive integer at the very end of the output following a colon (:)
    directive=${out##*:}
    # Remove the directive
    out=${out%:*}
    if [[ ${directive} == "${out}" ]]; then
        # There is not directive specified
        directive=0
    fi
    __glab_debug "The completion directive is: ${directive}"
    __glab_debug "The completions are: ${out}"
}

__glab_process_completion_results() {
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16
    local shellCompDirectiveKeepOrder=32

    if (((directive & shellCompDirectiveError) != 0)); then
        # Error code.  No completion.
        __glab_debug "Received error from custom completion go code"
        return
    else
        if (((directive & shellCompDirectiveNoSpace) != 0)); then
            if [[ $(type -t compopt) == builtin ]]; then
                __glab_debug "Activating no space"
                compopt -o nospace
            else
                __glab_debug "No space directive not supported in this version of bash"
            fi
        fi
        if (((directive & shellCompDirectiveKeepOrder) != 0)); then
            if [[ $(type -t compopt) == builtin ]]; then
                # no sort isn't supported for bash less than < 4.4
                if [[ ${BASH_VERSINFO[0]} -lt 4 || ( ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -lt 4 ) ]]; then
                    __glab_debug "No sort directive not supported in this version of bash"
                else
                    __glab_debug "Activating keep order"
                    compopt -o nosort
                fi
            else
                __glab_debug "No sort directive not supported in this version of bash"
            fi
        fi
        if (((directive & shellCompDirectiveNoFileComp) != 0)); then
            if [[ $(type -t compopt) == builtin ]]; then
                __glab_debug "Activating no file completion"
                compopt +o default
            else
                __glab_debug "No file completion directive not supported in this version of bash"
            fi
        fi
    fi

    # Separate activeHelp from normal completions
    local completions=()
    local activeHelp=()
    __glab_extract_activeHelp

    if (((directive & shellCompDirectiveFilterFileExt) != 0)); then
        # File extension filtering
        local fullFilter filter filteringCmd

        # Do not use quotes around the $completions variable or else newline
        # characters will be kept.
        for filter in ${completions[*]}; do
            fullFilter+="$filter|"
        done

        filteringCmd="_filedir $fullFilter"
        __glab_debug "File filtering command: $filteringCmd"
        $filteringCmd
    elif (((directive & shellCompDirectiveFilterDirs) != 0)); then
        # File completion for directories only

        local subdir
        subdir=${completions[0]}
        if [[ -n $subdir ]]; then
            __glab_debug "Listing directories in $subdir"
            pushd "$subdir" >/dev/null 2>&1 && _filedir -d && popd >/dev/null 2>&1 || return
        else
            __glab_debug "Listing directories in ."
            _filedir -d
        fi
    else
        __glab_handle_completion_types
    fi

    __glab_handle_special_char "$cur" :
    __glab_handle_special_char "$cur" =

    # Print the activeHelp statements before we finish
    if ((${#activeHelp[*]} != 0)); then
        printf "\n";
        printf "%s\n" "${activeHelp[@]}"
        printf "\n"

        # The prompt format is only available from bash 4.4.
        # We test if it is available before using it.
        if (x=${PS1@P}) 2> /dev/null; then
            printf "%s" "${PS1@P}${COMP_LINE[@]}"
        else
            # Can't print the prompt.  Just print the
            # text the user had typed, it is workable enough.
            printf "%s" "${COMP_LINE[@]}"
        fi
    fi
}

# Separate activeHelp lines from real completions.
# Fills the $activeHelp and $completions arrays.
__glab_extract_activeHelp() {
    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}

    while IFS='' read -r comp; do
        if [[ ${comp:0:endIndex} == $activeHelpMarker ]]; then
            comp=${comp:endIndex}
            __glab_debug "ActiveHelp found: $comp"
            if [[ -n $comp ]]; then
                activeHelp+=("$comp")
            fi
        else
            # Not an activeHelp line but a normal completion
            completions+=("$comp")
        fi
    done <<<"${out}"
}

__glab_handle_completion_types() {
    __glab_debug "__glab_handle_completion_types: COMP_TYPE is $COMP_TYPE"

    case $COMP_TYPE in
    37|42)
        # Type: menu-complete/menu-complete-backward and insert-completions
        # If the user requested inserting one completion at a time, or all
        # completions at once on the command-line we must remove the descriptions.
        # https://github.com/spf13/cobra/issues/1508
        local tab=$'\t' comp
        while IFS='' read -r comp; do
            [[ -z $comp ]] && continue
            # Strip any description
            comp=${comp%%$tab*}
            # Only consider the completions that match
            if [[ $comp == "$cur"* ]]; then
                COMPREPLY+=("$comp")
            fi
        done < <(printf "%s\n" "${completions[@]}")
        ;;

    *)
        # Type: complete (normal completion)
        __glab_handle_standard_completion_case
        ;;
    esac
}

__glab_handle_standard_completion_case() {
    local tab=$'\t' comp

    # Short circuit to optimize if we don't have descriptions
    if [[ "${completions[*]}" != *$tab* ]]; then
        IFS=$'\n' read -ra COMPREPLY -d '' < <(compgen -W "${completions[*]}" -- "$cur")
        return 0
    fi

    local longest=0
    local compline
    # Look for the longest completion so that we can format things nicely
    while IFS='' read -r compline; do
        [[ -z $compline ]] && continue
        # Strip any description before checking the length
        comp=${compline%%$tab*}
        # Only consider the completions that match
        [[ $comp == "$cur"* ]] || continue
        COMPREPLY+=("$compline")
        if ((${#comp}>longest)); then
            longest=${#comp}
        fi
    done < <(printf "%s\n" "${completions[@]}")

    # If there is a single completion left, remove the description text
    if ((${#COMPREPLY[*]} == 1)); then
        __glab_debug "COMPREPLY[0]: ${COMPREPLY[0]}"
        comp="${COMPREPLY[0]%%$tab*}"
        __glab_debug "Removed description from single completion, which is now: ${comp}"
        COMPREPLY[0]=$comp
    else # Format the descriptions
        __glab_format_comp_descriptions $longest
    fi
}

__glab_handle_special_char()
{
    local comp="$1"
    local char=$2
    if [[ "$comp" == *${char}* && "$COMP_WORDBREAKS" == *${char}* ]]; then
        local word=${comp%"${comp##*${char}}"}
        local idx=${#COMPREPLY[*]}
        while ((--idx >= 0)); do
            COMPREPLY[idx]=${COMPREPLY[idx]#"$word"}
        done
    fi
}

__glab_format_comp_descriptions()
{
    local tab=$'\t'
    local comp desc maxdesclength
    local longest=$1

    local i ci
    for ci in ${!COMPREPLY[*]}; do
        comp=${COMPREPLY[ci]}
        # Properly format the description string which follows a tab character if there is one
        if [[ "$comp" == *$tab* ]]; then
            __glab_debug "Original comp: $comp"
            desc=${comp#*$tab}
            comp=${comp%%$tab*}

            # $COLUMNS stores the current shell width.
            # Remove an extra 4 because we add 2 spaces and 2 parentheses.
            maxdesclength=$(( COLUMNS - longest - 4 ))

            # Make sure we can fit a description of at least 8 characters
            # if we are to align the descriptions.
            if ((maxdesclength > 8)); then
                # Add the proper number of spaces to align the descriptions
                for ((i = ${#comp} ; i < longest ; i++)); do
                    comp+=" "
                done
            else
                # Don't pad the descriptions so we can fit more text after the completion
                maxdesclength=$(( COLUMNS - ${#comp} - 4 ))
            fi

            # If there is enough space for any description text,
            # truncate the descriptions that are too long for the shell width
            if ((maxdesclength > 0)); then
                if ((${#desc} > maxdesclength)); then
                    desc=${desc:0:$(( maxdesclength - 1 ))}
                    desc+="…"
                fi
                comp+="  ($desc)"
            fi
            COMPREPLY[ci]=$comp
            __glab_debug "Final comp: $comp"
        fi
    done
}

__start_glab()
{
    local cur prev words cword split

    COMPREPLY=()

    # Call _init_completion from the bash-completion package
    # to prepare the arguments properly
    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion -n =: || return
    else
        __glab_init_completion -n =: || return
    fi

    __glab_debug
    __glab_debug "========= starting completion logic =========="
    __glab_debug "cur is ${cur}, words[*] is ${words[*]}, #words[@] is ${#words[@]}, cword is $cword"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $cword location, so we need
    # to truncate the command-line ($words) up to the $cword location.
    words=("${words[@]:0:$cword+1}")
    __glab_debug "Truncated words[*]: ${words[*]},"

    local out directive
    __glab_get_completion_results
    __glab_process_completion_results
}

if type globus > /dev/null 2>&1; then
        eval "$(globus --bash-completer)"
fi

if [[ $(type -t compopt) = "builtin" ]]; then
    complete -o default -F __start_glab glab
else
    complete -o default -o nospace -F __start_glab glab
fi

# ssh stuff
mkdir -p ~/.ssh/controlmasters  # make sure ssh control masters folder exists

# Source - https://stackoverflow.com/a/18915067
# Posted by Litmus, modified by community. See post 'Timeline' for change history
# Retrieved 2026-02-20, License - CC BY-SA 4.0

SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' >"$SSH_ENV"
    echo succeeded
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" >/dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "$SSH_ENV" ]; then
    . "$SSH_ENV" >/dev/null
    #ps $SSH_AGENT_PID doesn't work under Cygwin
    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent$ >/dev/null || {
        start_agent
    }
else
    start_agent
fi


export HOMEBREW_PREFIX=/opt/homebrew


# vi prompt
set -o vi
set editing-mode vi
set show-mode-in-prompt on   # only works in bash >4.3
set vi-ins-mode-string "\[\033[32m\]+\[\033[00m\]"
set vi-cmd-mode-string "\[\033[34m\]:\[\033[00m\]"
export PS1="◀ \n \s \v $user@\[\033[33m\]\H\[\033[00m\]:\w$gitstat${VENV}$term "
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

# ex: ts=4 sw=4 et filetype=sh
