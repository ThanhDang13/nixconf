{ ... }: {
  flake.nixosModules.adspower = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.callPackage ../../pkgs/adspower { })
    ];
  };
}