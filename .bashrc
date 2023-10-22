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

# re-style the prompt
BRACKET_COLOR="\[\033[38;5;35m\]"
CLOCK_COLOR="\[\033[38;5;35m\]"
JOB_COLOR="\[\033[38;5;33m\]"
PATH_COLOR="\[\033[38;5;33m\]"
LINE_BOTTOM="\342\224\200"
LINE_BOTTOM_CORNER="\342\224\224"
LINE_COLOR="\[\033[38;5;248m\]"
LINE_STRAIGHT="\342\224\200"
LINE_UPPER_CORNER="\342\224\214"
END_CHARACTER="|"

tty -s && export PS1="$LINE_COLOR$LINE_UPPER_CORNER$LINE_STRAIGHT$LINE_STRAIGHT$BRACKET_COLOR[$CLOCK_COLOR\t$BRACKET_COLOR]$LINE_COLOR$LINE_STRAIGHT$BRACKET_COLOR[$JOB_COLOR\j$BRACKET_COLOR]$LINE_COLOR$LINE_STRAIGHT$BRACKET_COLOR[\u@\H:\]$PATH_COLOR\w\$(__git_ps1)$BRACKET_COLOR]\n$LINE_COLOR$LINE_BOTTOM_CORNER$LINE_STRAIGHT$LINE_BOTTOM$END_CHARACTER\[$(tput sgr0)\] "
