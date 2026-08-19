{ self, inputs, ... }: {

  flake.nixosModules.zsh = { pkgs, lib, ... }:
    let
      sZsh = self.packages.${pkgs.stdenv.hostPlatform.system}.sZsh;
    in {
      environment.shells = [ (lib.getExe sZsh) ];
      users.users.sakata.shell = sZsh;
    };

  perSystem = { pkgs, lib, self', ... }: {
    packages.sZsh = inputs.wrapper-modules.wrappers.zsh.wrap {
      inherit pkgs;

      hmSessionVariables = null;

      runtimePkgs = with pkgs; [
        git
        starship
        zoxide
        fzf
        eza
        bat
        ripgrep
        openssh
        wl-clipboard
        neovim
      ];

      zshAliases = {
        ll = "eza -lah --icons --group-directories-first";
        ls = "eza --icons --group-directories-first";
        tree = "eza --tree --icons";
        cat = "bat";
        grep = "rg";
        cd = "z";
        ".." = "cd ..";
        "..." = "cd ../..";
        "~" = "cd ~";
        c = "clear";
        vim = "nvim";
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        clip = "wl-copy";
      };

      zshenv.content = ''
        export PATH="$HOME/.local/bin:$PATH"
        export HERMES_HOME="$HOME/.hermes"
      '';

      zshrc.content = ''
        # =========================
        # ZINIT SETUP
        # =========================
        ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"

        if [ ! -d "$ZINIT_HOME" ]; then
            mkdir -p "$(dirname "$ZINIT_HOME")"
            git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
        fi

        source "''${ZINIT_HOME}/zinit.zsh"

        # =========================
        # COMPLETIONS (must be early for plugins)
        # =========================
        autoload -Uz compinit
        compinit

        # =========================
        # ZINIT PLUGINS
        # =========================
        zinit light zsh-users/zsh-syntax-highlighting
        ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(autosuggest-accept)
        ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=()
        zinit light zsh-users/zsh-autosuggestions
        zinit light zsh-users/zsh-completions
        zinit light Aloxaf/fzf-tab

        # =========================
        # OMZ SNIPPETS
        # =========================
        zinit ice wait lucid
        zinit snippet OMZL::completion.zsh
        zinit snippet OMZL::git.zsh
        zinit snippet OMZP::git
        zinit snippet OMZP::sudo

        zinit snippet OMZP::docker/completions/_docker
        zinit snippet OMZP::docker-compose
        zinit snippet OMZP::command-not-found
        zinit snippet OMZP::common-aliases
        zinit snippet OMZP::npm

        # =========================
        # MODERN CLI TOOLS (runtime only)
        # =========================
        eval "$(zoxide init zsh)"
        eval "$(starship init zsh)"
        eval "$(fnm env --use-on-cd --corepack-enabled)"

        source <(fzf --zsh)

        # =========================
        # ZINIT POSTLOAD
        # =========================
        zinit cdreplay -q

        # =========================
        # KEYBINDINGS
        # =========================
        bindkey -e

        bindkey '^P' history-search-backward
        bindkey '^N' history-search-forward

        bindkey '^A' beginning-of-line
        bindkey '^E' end-of-line
        bindkey '^B' backward-char
        bindkey '^F' forward-char
        bindkey '^[b' backward-word
        bindkey '^[f' forward-word

        bindkey '^W' backward-kill-word
        bindkey '^[d' kill-word
        bindkey '^U' backward-kill-line
        bindkey '^K' kill-line
        bindkey '^Y' yank
        bindkey '^[w' kill-region
        bindkey '^_' undo
        bindkey '^?' backward-delete-char
        bindkey '^D' delete-char

        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward

        bindkey '^@' autosuggest-accept

        # =========================
        # HISTORY SETTINGS
        # =========================
        HISTSIZE=5000
        HISTFILE=~/.zsh_history
        SAVEHIST=$HISTSIZE

        setopt appendhistory
        setopt sharehistory
        setopt hist_ignore_space
        setopt hist_ignore_all_dups
        setopt hist_save_no_dups
        setopt hist_ignore_dups
        setopt hist_find_no_dups

        # =========================
        # COMPLETION STYLING
        # =========================
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu yes

        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


        # =========================
        # SSH
        # =========================
        if ! pgrep -u "$USER" ssh-agent > /dev/null; then
          eval "$(ssh-agent -s)" > /dev/null
        fi
        ssh-add ~/.ssh/github 2>/dev/null
      '';
    };
  };

}