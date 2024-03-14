reset_tty() {
    tty -s && export PS1="$LINE_COLOR$LINE_UPPER_CORNER$LINE_STRAIGHT$LINE_STRAIGHT$BRACKET_COLOR[$CLOCK_COLOR\t$BRACKET_COLOR]$LINE_COLOR$LINE_STRAIGHT$BRACKET_COLOR[$JOB_COLOR\j$BRACKET_COLOR]$LINE_COLOR$LINE_STRAIGHT$BRACKET_COLOR[$USER_COLOR\u$HOST_COLOR@\H:\]$PATH_COLOR\w\$(__git_ps1)$BRACKET_COLOR]\n$LINE_COLOR$LINE_BOTTOM_CORNER$LINE_STRAIGHT$LINE_BOTTOM$END_CHARACTER\[$(tput sgr0)\] "
}

term_color() {
    if [ -n "$2" ]; then
        echo -e "\e[38;5;${1-"0"};48;5;${2-"0"}m"
    else
        echo -e "\e[38;5;${1-"0"}m"
    fi
}

term_style() {
    echo -e "\e[${1-"0"}m"
}

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# allow __git_ps1 to be included in the prompt
#
# Ubuntu
if [ -f  /usr/lib/git-core/git-sh-prompt ]; then
	source  /usr/lib/git-core/git-sh-prompt
fi
# Nix
if [ -f  /run/current-system/sw/share/bash-completion/completions/git-prompt.sh ]; then
	source  /run/current-system/sw/share/bash-completion/completions/git-prompt.sh
fi

# Update default application for text editing
export VISUAL=nvim
export EDITOR="$VISUAL"

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1

# export display style
export CHAR_NORMAL="$(term_style 0)"
export CHAR_UNDERLINE="$(term_style 4)"


# export color constants
export COLOR_GREEN=$(term_color 35)
export COLOR_BLUE=$(term_color 33)

# re-style the prompt
BRACKET_COLOR=$COLOR_GREEN
BRACKET_COLOR=$COLOR_GREEN
CLOCK_COLOR=$COLOR_GREEN
JOB_COLOR=$COLOR_BLUE
PATH_COLOR=$COLOR_BLUE
USER_COLOR=""
HOST_COLOR=""

LINE_BOTTOM="\342\224\200"
LINE_BOTTOM_CORNER="\342\224\224"
LINE_COLOR="\[\033[38;5;248m\]"
LINE_STRAIGHT="\342\224\200"
LINE_UPPER_CORNER="\342\224\214"
END_CHARACTER="|"

reset_tty
