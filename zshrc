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

# better vi keybindings
source $HOME/.dotfiles/zsh-vi-mode/zsh-vi-mode.plugin.zsh
# Wait only 10ms after pressing Escape to switch to normal mode
# If I set the timeout smaller than this, the cursor/prompt doesn't update
export ZVM_KEYTIMEOUT=0.01
# enable fzf keybindings (ctrl-R for history search, ctrl-T for file search)
# this needs to happen via zvm to avoid overwriting keybindings
zvm_after_init_commands+=('[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh')

function zvm_after_lazy_keybindings() {
    # Ctrl-Space to accept suggestions (the arrow key is too far away)
    bindkey '^ ' autosuggest-accept
}

# colors
alias ls='ls --color=auto'
# really fancy colored manpages using bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

alias lisa_down="rsync -rLKv --exclude=\".*\" lgpu0383@lisa.surfsara.nl:~/ ~/Documents/university/present/dl/lisa/"
alias lisa_up="rsync -rLKv --exclude=\".*\" ~/Documents/university/present/dl/lisa/ lgpu0383@lisa.surfsara.nl:~/"
alias lisa_connect="ssh lgpu0133@lisa.surfsara.nl"

alias up='cd ..'

# command to interact with the bare git repository containing all dotfiles
# Usage: e.g. $ cfg commit -m 'Change some config files'
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

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
