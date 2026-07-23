{ self, inputs, ... }: {
  
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.sniri;
      useNautilus = true;
    };

    environment.systemPackages = [
        pkgs.grim
        pkgs.slurp
        pkgs.wl-clipboard
        pkgs.swappy
    ];

    imports = [
     self.nixosModules.niri-touchpad-toggle
     self.nixosModules.noctalia-kbd-sync
     self.nixosModules.wl-mirror
     self.nixosModules.xdg
    ];

    xdg.portal.config = {
      niri = {
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.Screenshot" = "gnome";
        "org.freedesktop.impl.portal.FileChooser" = "nautilus";
      };
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.sniri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      
      settings = {

        spawn-at-startup = [
          (lib.getExe self'.packages.snoctalia)
        ];

        hotkey-overlay.skip-at-startup = true;
    
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input.keyboard = {
          xkb.layout = "us,ua";
        };

        window-rules = [
          {
            geometry-corner-radius = 12;
            clip-to-geometry = true;
            draw-border-with-background = false;
          }
          {
            matches = [{ app-id = "^codium$"; }];
            opacity = 0.85;
          }
          {
            matches = [{ app-id = "^vesktop$"; }];
            opacity = 0.85;
          }
          {
            matches = [{ app-id = "^org\\.gnome\\.Nautilus$"; }];
            opacity = 0.85;
          }
        ];

        layout = {
          gaps = 12;

          focus-ring.off = _: { };

          border = {
            width = 1;
          };

          preset-column-widths = [
            { proportion = 0.5; }
            { proportion = 0.6; }
            { proportion = 1.0; }
          ];

          default-column-width = {
            proportion = 0.6;
          };
        };

        binds = {
          "Mod+Q".spawn-sh = lib.getExe self'.packages.skitty;
          "Mod+E".spawn-sh = lib.getExe pkgs.nautilus;
          "Mod+R".spawn-sh = "${lib.getExe self'.packages.snoctalia} ipc call launcher toggle";
          
          "Mod+W".switch-preset-column-width = { };
          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";
          "Mod+F".fullscreen-window = {};

          "Mod+Left".focus-column-left = { };
          "Mod+Down".focus-window-down = { };
          "Mod+Up".focus-window-up = { };
          "Mod+Right".focus-column-right = { };
          

          "Mod+Shift+Left".move-column-left = { };
          "Mod+Shift+Down".move-window-down = { };
          "Mod+Shift+Up".move-window-up = { };
          "Mod+Shift+Right".move-column-right = { };

          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;

          "Mod+Shift+1".move-window-to-workspace = 1;
          "Mod+Shift+2".move-window-to-workspace = 2;
          "Mod+Shift+3".move-window-to-workspace = 3;
          "Mod+Shift+4".move-window-to-workspace = 4;
          "Mod+Shift+5".move-window-to-workspace = 5;
          "Mod+Shift+6".move-window-to-workspace = 6;
          "Mod+Shift+7".move-window-to-workspace = 7;
          "Mod+Shift+8".move-window-to-workspace = 8;
          "Mod+Shift+9".move-window-to-workspace = 9;

          "Mod+C".close-window = { };
          "Mod+Tab".toggle-overview = { };

          "XF86MonBrightnessUp".spawn-sh = "${lib.getExe self'.packages.snoctalia} ipc call brightness increase"; 
          "XF86MonBrightnessDown".spawn-sh = "${lib.getExe self'.packages.snoctalia} ipc call brightness decrease"; 

          "XF86AudioNext".spawn-sh = "${lib.getExe self'.packages.snoctalia} ipc call media next";
          "XF86AudioPrev".spawn-sh = "${lib.getExe self'.packages.snoctalia} ipc call media previous";
          "XF86AudioPlay".spawn-sh = "${lib.getExe self'.packages.snoctalia} ipc call media playPause";
          "XF86AudioPause".spawn-sh = "${lib.getExe self'.packages.snoctalia} ipc call media playPause";

          "XF86KbdBrightnessUp".spawn-sh = "${lib.getExe pkgs.asusctl} leds next";
          "XF86KbdBrightnessDown".spawn-sh = "${lib.getExe pkgs.asusctl} leds prev";

          "XF86Launch3".spawn-sh = "${lib.getExe pkgs.asusctl} aura effect --next-mode";
          "XF86Launch1".spawn-sh = "${lib.getExe' pkgs.asusctl "rog-control-center"}";
          "XF86Launch4".spawn-sh = "${lib.getExe pkgs.asusctl} profile next";

          "XF86AudioRaiseVolume".spawn-sh = "${lib.getExe self'.packages.snoctalia} ipc call volume increase";
          "XF86AudioLowerVolume".spawn-sh = "${lib.getExe self'.packages.snoctalia} ipc call volume decrease";
          "XF86AudioMute".spawn-sh = "${lib.getExe self'.packages.snoctalia} ipc call volume muteOutput";
          "XF86AudioMicMute".spawn-sh = "${lib.getExe self'.packages.snoctalia} ipc call volume muteInput";

          "Mod+Shift+S".spawn-sh = ''${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" - | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}'';
          "Print".spawn-sh = ''${lib.getExe pkgs.grim} - | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}'';
          "Shift+Print".spawn-sh = ''${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png'';
          "Ctrl+Print".screenshot-window = { };

          "XF86TouchpadToggle".spawn-sh = "niri-toggle-touchpad";
          "Mod+P".spawn-sh = "mirror-display";

          "XF86Sleep".spawn-sh = "${lib.getExe' pkgs.systemd "systemctl"} suspend";

          "XF86Launch5".spawn-sh = "${lib.getExe' pkgs.networkmanager "nmcli"} radio all off";
          "SHIFT+XF86Launch5".spawn-sh = "${lib.getExe' pkgs.networkmanager "nmcli"} radio all on";

          "Mod+I".spawn-sh = "${lib.getExe self'.packages.snoctalia} ipc call settings toggle";
          "Mod+L".spawn-sh = "${lib.getExe self'.packages.snoctalia} ipc call lockScreen lock"; 
        };  

        extraConfig = ''
          include optional=true "~/.config/niri/noctalia.kdl"
          include optional=true "~/.config/niri/touchpad-current.kdl"
        '';
      };
    };
   
  };

}
