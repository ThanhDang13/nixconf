{ ... }: {
  flake.nixosModules.niri-touchpad-toggle = { pkgs, ... }: {
    environment.etc."niri-touchpad/on.kdl".text = ''
      input {
          touchpad {
              tap
              natural-scroll
              dwt
          }
      }
    '';

    environment.etc."niri-touchpad/off.kdl".text = ''
      input {
          touchpad {
              off
          }
      }
    '';

    environment.systemPackages =
      let
        toggleScript = pkgs.writeShellApplication {
          name = "niri-toggle-touchpad";
          runtimeInputs = [ pkgs.libnotify ];
          text = ''
            LINK="$HOME/.config/niri/touchpad-current.kdl"
            ON="/etc/niri-touchpad/on.kdl"
            OFF="/etc/niri-touchpad/off.kdl"

            mkdir -p "$(dirname "$LINK")"

            CURRENT_TARGET="$(readlink -f "$LINK" 2>/dev/null || true)"
            OFF_TARGET="$(readlink -f "$OFF")"

            if [ -z "$CURRENT_TARGET" ] || [ "$CURRENT_TARGET" = "$OFF_TARGET" ]; then
              ln -sf "$ON" "$LINK"
              notify-send -t 800 -u low -a "System" "Touchpad enabled"
            else
              ln -sf "$OFF" "$LINK"
              notify-send -t 800 -u low -a "System" "Touchpad disabled"
            fi
          '';
        };
      in
      [ toggleScript ];
  };
}