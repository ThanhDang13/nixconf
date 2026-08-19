{ self, ... }: {
  perSystem = { pkgs, ... }: {
    packages.noctalia-sync = let
      obsidianCssTemplate = ./obsidian.css;

      vaults = [
        "/home/sakata/workspace/vaults/home"
      ];

      kbdColorTemplate = pkgs.writeText "kbd-color.txt" ''
        {{colors.primary.default.hex}}
      '';

      setKbdColor = pkgs.writeShellScript "set-kbd-color.sh" ''
        HEX=$(${pkgs.coreutils}/bin/cat "$HOME/.cache/noctalia/kbd-color.hex" | ${pkgs.coreutils}/bin/tr -d '#\n ')
        ${pkgs.asusctl}/bin/asusctl aura effect static -c "$HEX"
      '';

      obsidianEntries = pkgs.lib.concatMapStrings (vault: ''
        [templates.obsidian_${builtins.baseNameOf vault}]
        input_path  = "${obsidianCssTemplate}"
        output_path = "${vault}/.obsidian/snippets/noctalia.css"

      '') vaults;

      userTemplatesToml = pkgs.writeText "user-templates.toml" ''
        [templates.kbd-color]
        input_path  = "${kbdColorTemplate}"
        output_path = "~/.cache/noctalia/kbd-color.hex"
        post_hook   = "${setKbdColor}"

        ${pkgs.lib.optionalString (vaults != []) obsidianEntries}
      '';
    in
    pkgs.writeShellApplication {
      name = "noctalia-sync";
      runtimeInputs = [ pkgs.coreutils ];
      text = ''
        if [ ! -L "$HOME/.config/noctalia/user-templates.toml" ] || [ "$(readlink "$HOME/.config/noctalia/user-templates.toml")" != "${userTemplatesToml}" ]; then
          mkdir -p "$HOME/.config/noctalia"
          ln -sf "${userTemplatesToml}" "$HOME/.config/noctalia/user-templates.toml"
          echo "Noctalia sync configuration updated successfully."
        fi
      '';
    };
  };

  flake.nixosModules.noctalia-sync = { pkgs, ... }: {
    systemd.user.services.noctalia-sync = {
      description = "Sync noctalia templates";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-sync}/bin/noctalia-sync";
      };
    };

    system.userActivationScripts.noctalia-sync = {
      text = ''
        ${self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-sync}/bin/noctalia-sync
      '';
    };
  };
}