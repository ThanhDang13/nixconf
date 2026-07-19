{ ... }: {
  flake.nixosModules.rog = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.asusctl
    ];

    programs.rog-control-center.enable = true;

    services.asusd = {
        enable = true;
    };

    services.supergfxd.enable = true;

    environment.sessionVariables = {
      GDK_BACKEND = "wayland,x11";
    };
  };
}