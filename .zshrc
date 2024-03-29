# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#######################
##### OTHER VARS ######
#######################
export EDITOR='vim'

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="hyperzsh"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions brew macos colored-man-pages jsontools)

source $ZSH/oh-my-zsh.sh

######################
##### GENERAL CONFIGS
######################
fpath+=/opt/homebrew/share/zsh/site-functions
autoload -U promptinit; promptinit
prompt pure

#######################
### ALIASES ###########
#######################
alias vime='sudo vim ~/.vimrc'
alias src='source ~/.zshrc'

#Docker
alias dc="docker-compose"
alias d="docker"
alias dprune="docker system prune -a --volumes"

#tmux
alias tmux="TERM=screen-256color-bce tmux"
alias tattach='foo(){tmux a -t "$1"}; foo'
alias work='tmuxinator start jobwise'
alias dev='tmuxinator start home'

# General Rewrites + Navigation
alias ls='ls -GF'
alias cdw='foo(){ cd ~/workspace/"$1"}; foo '
alias rage='foo(){ rm -rf "$1"}; foo'

# Git
alias gpm="git pull origin main"
alias rebase='gpm && git push origin HEAD'
alias gc="git checkout"
alias gs="git status"
alias gp="git pull"
alias gi="echo -e 'a\n*\nq\n'|git add -i"

#function gc() {
	#if [ "$1" != "" ] # or better, if [ -n "$1" ]
	#then
		#git commit -m "$1"
	#else
		#git commit -m update
	#fi
#}
function sendno() {
	git add --patch
	if [ "$1" != "" ] # or better, if [ -n "$1" ]
	then
		git commit -m "$1" --no-verify
	else
		git commit -m update --no-verify
	fi
	git push -u origin HEAD --no-verify
}
function send() {
	git add --patch
	if [ "$1" != "" ] # or better, if [ -n "$1" ]
	then
		git commit -m "$1"
	else
		git commit -m update
	fi
	git push -u origin HEAD
}

#Other tools
alias pid='foo(){ lsof -nP -i4TCP:"$1" | grep LISTEN }; foo'
alias ngrok='foo(){ ngrok http "$1"}; foo'
alias loct='foo(){ lt --port "$1" --subdomain "$2"}; foo'

#######################
### AUTO GENERATED
#######################

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
