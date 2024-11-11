#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# shell prompt sign
PS1='[\u@\h \W]\$ '

# some alias, but they can not inherited by fish
alias ll='ls -la --color=auto'
alias rscp="rsync -avPz --rsh=ssh"
if [[ -x $(command -v proxychains4) &&  -e $HOME/.proxychains4.conf ]]; then
	alias proxychains4='proxychains4 -f $HOME/.proxychains4.conf'
fi

# import `$HOME/opt` as custom root path
export C_INCLUDE_PATH=$HOME/opt/usr/include/:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=$HOME/opt/usr/include/:$CPLUS_INCLUDE_PATH
export CPATH=$HOME/opt/usr/include/:$CPATH
export LD_LIBRARY_PATH=$HOME/opt/usr/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=$HOME/opt/usr/lib:$LIRARY_PATH
export MANPATH=$HOME/opt/usr/man:$MANPATH
export PATH=$HOME/opt/usr/bin:$PATH

# set default editor
export EDITOR=/usr/bin/vim

# proxy
export all_proxy=
export http_proxy=
export https_proxy=

# fzf: command-line fuzzy finder
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview-window down:5'
## use `fd` to speed up `fzf`
if [[ -x $(command -v fd) ]]; then
    export FZF_DEFAULT_COMMAND='fd -u --type file'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd -t d . $HOME"
else
    export FZF_DEFAULT_COMMAND='find . -type f'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="find $HOME -type d"
fi

# fish: friendly interactive shell
if [[ -x $(command -v fish) && $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]; then
    exec fish
fi
