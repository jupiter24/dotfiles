# History options (need to be set for any history to be saved)
HISTFILE=~/.zshhist
# max history entries loaded into memory
HISTSIZE=10000
# max history entries in file
SAVEHIST=10000
setopt share_history

# Activate TAB autocompletion
autoload -Uz compinit
compinit

# Activate prompt theme system
autoload -Uz promptinit
promptinit
# Use the 'pure' prompt
prompt pure

# use z to quickly jump to folders:
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# Enable syntax highlighting as in fish
# Requires zsh-syntax-highlighting to be installed
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Enable autosuggestions as in fish
# Requires zsh-autosuggestions to be installed
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=14"
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)

# better vi keybindings
source $HOME/.dotfiles/zsh-vi-mode/zsh-vi-mode.plugin.zsh
# enable fzf keybindings (ctrl-R for history search, ctrl-T for file search)
# this needs to happen via zvm to avoid overwriting keybindings
zvm_after_init_commands+=('[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh')

function zvm_after_lazy_keybindings() {
    # Ctrl-Space to accept suggestions (the arrow key is too far away)
    bindkey '^ ' autosuggest-accept
}

# Patch zvm's yank and paste function to integrate with system clipboard
functions[zvm_yank]="
    $functions[zvm_yank]
    echo \$CUTBUFFER | xclip -selection clipboard"
functions[zvm_vi_put_after]="
    CUTBUFFER=\$(xclip -o -selection clipboard)
    $functions[zvm_vi_put_after]"
functions[zvm_vi_put_before]="
    CUTBUFFER=\$(xclip -o -selection clipboard)
    $functions[zvm_vi_put_before]"

# colors
alias ls='ls --color=auto'
# really fancy colored manpages using bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

alias up='cd ..'

source /etc/profile.d/autojump.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/erik/.miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/erik/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/erik/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/erik/.miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# don't use conda environment by default
conda deactivate
