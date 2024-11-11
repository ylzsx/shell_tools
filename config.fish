if status is-interactive
    # Commands to run in interactive sessions can go here
end

# some alias
alias ll='ls -la --color=auto'
alias rscp='rsync -avPz --rsh=ssh'
if type -q proxychains4; and test -e $HOME/.proxychains4.conf
    alias proxychains4="proxychains4 -f $HOME/.proxychains4.conf"
end

