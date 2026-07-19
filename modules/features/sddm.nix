{ ... }: {
  flake.nixosModules.sddm = { pkgs, ... }: {
    environment.systemPackages = [
      ((pkgs.sddm-astronaut.override {
        embeddedTheme = "japanese_aesthetic";
        themeConfig = {
          HeaderTextColor = "#d582eabf";
          Background = "Backgrounds/sddm-wallpaper.png";
        };
      }).overrideAttrs (oldAttrs: {
        installPhase = oldAttrs.installPhase + ''
          chmod u+w $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/
          cp ${./sddm-wallpaper.png} \
            $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/sddm-wallpaper.png
        '';
      }))
    ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs; [
        kdePackages.qtmultimedia
      ];
      theme = "sddm-astronaut-theme";
    };
  };
}