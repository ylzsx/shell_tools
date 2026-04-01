if status is-interactive
    # Commands to run in interactive sessions can go here
end

# some alias
alias ll='ls -la --color=auto'
alias rscp='rsync -avPz --rsh=ssh'

if type -q proxychains4; and test -e $HOME/.proxychains4.conf
  alias proxychains4="proxychains4 -f $HOME/.proxychains4.conf"
end

if type -q fzf;
  fzf --fish | source
end

function fish_prompt -d "Write out the prompt"
  printf '%s@%s%s%s%s> ' (whoami) (hostname -I | cut -d' ' -f1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

