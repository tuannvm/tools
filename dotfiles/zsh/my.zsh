setopt noincappendhistory
export TERM="xterm-256color"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=240"
export DISABLE_AUTO_TITLE='true'
export PATH=/usr/local/bin:$PATH:~/golang/bin
export LC_ALL=en_US.UTF-8
export EDITOR=/usr/bin/vi
export FZF_DEFAULT_COMMAND='rg --files'

bindkey -s '^o' 'lfcd\n'  # zsh

lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
  if [ -x "$(command -v nvr)" ]; then
    alias vi='nvr -lO'
    export VISUAL='nvr -cc split --remote-wait +"set bufhidden=wipe"'
  else
    alias vi='echo "No nesting!"'
  fi
else
  export VISUAL=/usr/bin/vi
fi

