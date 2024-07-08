###################
# Alias a command if the given dependency exists
# Arguments:
#  $1 the command dependency of the alias
#  $2 the alias to create
###################
alias_if_exists() {
    if command -v $1 > /dev/null 2>&1; then
        alias $2
    fi
}

# Allow my vim muscle memory to do what I want
alias :q="exit"

alias_if_exists bat 'cat="bat"'

alias_if_exists lsd 'ls="lsd"'

# Ping weather with optional location parameter
wttr() {
	#get local weather
	curl wttr.in/"$1"?MnF2
}
