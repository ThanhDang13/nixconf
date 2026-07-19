{ ... }: {
  flake.nixosModules.vscodium = { pkgs, ... }: {

    environment.systemPackages = [
      pkgs.vscodium
    ];

    environment.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

  };
}
