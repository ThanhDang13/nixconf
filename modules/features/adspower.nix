{ root, ... }: {
  flake.nixosModules.adspower = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.callPackage (root + /pkgs/adspower) { })
    ];
  };
}