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

# proxychains can read $HOME/.proxychains/proxychains.conf

# import `$HOME/opt` as custom root path
export PREFIX=$HOME/opt/usr
export PATH=$PREFIX/bin:$PATH
export C_INCLUDE_PATH=$PREFIX/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=$PREFIX/include:$CPLUS_INCLUDE_PATH
export CPATH=$PREFIX/include:$CPATH
export LIBRARY_PATH=$PREFIX/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig:$PKG_CONFIG_PATH
export MANPATH=$PREFIX/share/man:$PREFIX/man:${MANPATH:-}

# set default editor
export EDITOR=/usr/bin/vim

# set the path to the custom python functions
export PYTHONPATH=$PYTHONPATH:$HOME/shell_tools/mpy_script/

# proxy
PROXY=
export all_proxy=$PROXY
export http_proxy=$PROXY
export https_proxy=$PROXY

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
if [[ -x $(command -v fish) && $(ps --no-header --pid=$PPID --format=cmd) != "fish" && -z $(tty | grep '/dev/tty') ]]; then
    exec fish
fi
