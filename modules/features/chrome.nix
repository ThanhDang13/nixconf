{ ... }: {
  flake.nixosModules.chrome = { pkgs, ... }: {

    environment.systemPackages = [
      pkgs.google-chrome
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    xdg.portal = {
      enable = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
    };
  };
}
