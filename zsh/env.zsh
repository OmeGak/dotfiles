export FZF_DEFAULT_COMMAND='fd .'
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type=directory"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# FZF colors matching starship config
export FZF_DEFAULT_OPTS="
--layout=reverse
--info=inline
--multi --cycle --no-mouse
--preview-window=:hidden
--preview '([[ -f {} ]] && (bat --color=always --style=numbers --line-range=:500 {} || cat {})) || ([[ -d {} ]] && (tree {} | less)) || echo {} 2> /dev/null | head -200'
--prompt='∵ ' --pointer='·' --marker='·'
--bind '?:toggle-preview'
--bind 'ctrl-space:toggle'
--bind 'ctrl-a:toggle-all'
--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
--bind 'ctrl-e:execute(code {+})'
--bind 'ctrl-v:execute(echo {+} | xargs -o vim)'
--color='bg+:-1,fg+:015:bold:underline'
--color='hl:009:bold,hl+:009:bold:underline'
--color='prompt:008:bold,query:008:bold,spinner:009:bold,info:008:dim'
--color='pointer:009:bold,marker:009:bold'
--color='border:009:bold'
"
export FZF_CTRL_T_OPTS="--color='query:013:bold,hl:013:bold,hl+:013:bold:underline'"
export FZF_CTRL_R_OPTS="--color='query:010:bold,hl:010:bold,hl+:010:bold:underline'"
export FZF_ALT_C_OPTS="--color='query:012:bold,hl:012:bold,hl+:012:bold:underline'"
export STARSHIP_CONFIG="${HOME}/.starship"
