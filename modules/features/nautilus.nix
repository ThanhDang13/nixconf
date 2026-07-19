{ flake, pkgs, ... }: {
  flake.nixosModules.nautilus = { pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
      nautilus
      nautilus-open-any-terminal
      sushi
      (runCommandLocal "nautilus-portal" { } ''
        mkdir -p $out/share/xdg-desktop-portal/portals
        cat > $out/share/xdg-desktop-portal/portals/nautilus.portal <<EOF
        [portal]
        DBusName=org.gnome.Nautilus
        Interfaces=org.freedesktop.impl.portal.FileChooser
        EOF
      '')
    ];

    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.tumbler.enable = true;

    environment.sessionVariables = {
      GTK_USE_PORTAL = "1";
    };
  };
}