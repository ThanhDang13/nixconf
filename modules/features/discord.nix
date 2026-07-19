{ ... }: {
  flake.nixosModules.discord = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.vesktop
    ];
    nixpkgs.config.permittedInsecurePackages = [
      "electron-40.10.5"
    ];
  };
}