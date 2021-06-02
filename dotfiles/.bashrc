# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -f /etc/bash_completion ]; then
 . /etc/bash_completion
fi

# sets prompt colors for regular use and ssh
if [ ! -z $SSH_TTY ]; then
	export PS1="\e[0;97m\u@\e[m\e[1;31m\h:\e[m\e[0;37m\w\e[m \e[1;31m\$\e[m "
else
	export PS1="\e[0;97m\u@\e[m\e[1;36m\h:\e[m\e[0;37m\w\e[m \e[1;36m\$\e[m "
fi

# neofetch
alias neofetch="neofetch | sed 's/i5/Core i5/'"
clear; neofetch

alias neko="cat"

export EDITOR=vi
export TERMINAL=kitty
export WM=sway

# rsync aliases for syncing code to server
alias pushcode="rsync -a $HOME/github/ kugelblitz.me:/home/kugelblitz/github/"
alias pullcode="rsync -a kugelblitz.me:/home/kugelblitz/github/ $HOME/github/"

# aliases for connecting to wifi
alias initwifi="sudo sh $HOME/.wifi.sh initwifi"
alias addwifi="sudo sh $HOME/.wifi.sh addwifi"
alias clearwifi="sudo sh $HOME/.wifi.sh clearwifi"
alias resetwifi="sudo sh $HOME/.wifi.sh resetwifi"

alias rmss="rm ./*grim.png"

alias ls='ls --color=auto'
alias :q='exit'
