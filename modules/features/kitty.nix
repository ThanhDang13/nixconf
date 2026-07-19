{ self, inputs, ... }: {
  flake.nixosModules.kitty = { pkgs, lib, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.sKitty
    ];
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.sKitty =
      let
        kittyConfigText = ''
          font_family JetBrainsMono Nerd Font
          font_size 12

          enable_audio_bell no
          confirm_os_window_close 0
          cursor_blink_interval 0
          scrollback_lines 10000
          background_opacity 0.6
          remember_window_size no
          hide_window_decorations yes
          window_padding_width 0 15 0 15

          map ctrl+shift+t new_tab
          map ctrl+shift+w close_tab
          map ctrl+shift+c copy_to_clipboard
          map ctrl+shift+v paste_from_clipboard

          include optional=true "~/.config/kitty/themes/noctalia.conf"
        '';
        kittyConfigDir = pkgs.writeTextDir "kitty.conf" kittyConfigText;
      in
      pkgs.symlinkJoin {
        name = "kitty";
        paths = [ pkgs.kitty ];
        nativeBuildInputs = [ pkgs.makeWrapper ];

        postBuild = ''
          wrapProgram "$out/bin/kitty" \
            --set TERM "xterm-kitty" \
            --set KITTY_CONFIG_DIRECTORY "${kittyConfigDir}"
        '';
      };
  };
}