{ ... }: {
  flake.nixosModules.direnv = { pkgs, ... }: {

    environment.systemPackages = [
      pkgs.direnv
    ];

    environment.sessionVariables = {
      
    };
  };
}
