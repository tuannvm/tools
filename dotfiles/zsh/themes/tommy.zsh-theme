local ret_status="%(?:%{$fg_bold[green]%}λ:%{$fg_bold[green]%}λ)"
PROMPT="${ret_status} %{$fg[cyan]%}%c%{$reset_color%} %# "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[green]%}(%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%})"
