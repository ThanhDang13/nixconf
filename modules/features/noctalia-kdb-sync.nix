{ self, ... }: {
  perSystem = { pkgs, ... }: {
    packages.noctalia-kbd-sync = let
      kbdColorTemplate = pkgs.writeText "kbd-color.txt" ''
        {{colors.primary.default.hex}}
      '';

      setKbdColor = pkgs.writeShellScript "set-kbd-color.sh" ''
        HEX=$(${pkgs.coreutils}/bin/cat "$HOME/.cache/noctalia/kbd-color.hex" | ${pkgs.coreutils}/bin/tr -d '#\n ')
        ${pkgs.asusctl}/bin/asusctl aura effect static -c "$HEX"
      '';

      userTemplatesToml = pkgs.writeText "user-templates.toml" ''
        [templates.kbd-color]
        input_path  = "${kbdColorTemplate}"
        output_path = "~/.cache/noctalia/kbd-color.hex"
        post_hook   = "${setKbdColor}"
      '';
    in
    pkgs.writeShellApplication {
      name = "noctalia-kbd-sync";
      runtimeInputs = [ pkgs.coreutils ];
      text = ''
        if [ ! -L "$HOME/.config/noctalia/user-templates.toml" ] || [ "$(readlink "$HOME/.config/noctalia/user-templates.toml")" != "${userTemplatesToml}" ]; then
          mkdir -p "$HOME/.config/noctalia"
          ln -sf "${userTemplatesToml}" "$HOME/.config/noctalia/user-templates.toml"
          echo "Noctalia templates configuration updated successfully."
        fi
      '';
    };
  };

  flake.nixosModules.noctalia-kbd-sync = { pkgs, ... }: {
    systemd.user.services.noctalia-kbd-sync = {
      description = "Sync noctalia keyboard color template";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${self.packages.${pkgs.system}.noctalia-kbd-sync}/bin/noctalia-kbd-sync";
      };
    };
  };
}