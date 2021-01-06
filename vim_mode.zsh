# vim:ft=zsh
# https://github.com/JakobGM/dotfiles/blob/master/autoload/vim.zsh
# -------- Setup for vim functionality in ZSH --------
# Resources:
# Adding Vi To Your Zsh: https://dougblack.io/words/zsh-vi-mode.html
# Pure by Sindre Sørhus: https://github.com/sindresorhus/pure

# Use vim editing mode in terminal [escape to enter normal mode]
bindkey -v

# Restore some keymaps removed by vim keybind mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Dependencies for the following lines
zmodload zsh/zle

# Callback for vim mode change
function zle-keymap-select () {
    # Only supported in these terminals
    if [ "$TERM" = "xterm-256color" ] || [ "$TERM" = "xterm-kitty" ] || [ "$TERM" = "screen-256color" ]; then
        if [ $KEYMAP = vicmd ]; then
            # Command mode
            export RPROMPT="%{$fg[green]%}[NORMAL]%{$reset_color%}"

            # Set block cursor
            echo -ne '\e[1 q'
        else
            # Insert mode
            export RPROMPT="%{$fg[blue]%}[INSERT]%{$reset_color%}"

            # Set beam cursor
            echo -ne '\e[5 q'
        fi
    fi

    if typeset -f prompt_pure_update_vim_prompt_widget > /dev/null; then
        # Refresh prompt and call Pure super function
        prompt_pure_update_vim_prompt_widget
    fi
}

# Bind the callback
zle -N zle-keymap-select

# Reduce latency when pressing <Esc>
export KEYTIMEOUT=1
