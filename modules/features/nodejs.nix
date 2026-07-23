{ ... }: {
  flake.nixosModules.nodejs = { pkgs, ... }: {

    environment.systemPackages = [
      pkgs.fnm
    ];

    environment.sessionVariables = {
      
    };
  };
}
