if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias ll='ls -la'
alias rscp="rsync -avzP --rsh=ssh"

fzf --fish | source
