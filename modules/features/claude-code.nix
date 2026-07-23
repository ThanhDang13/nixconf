{ inputs, ... }: {
  flake.nixosModules.claude-code = { pkgs, ... }: {
    nixpkgs.overlays = [ inputs.claude-code.overlays.default ];

    nix.settings = {
     substituters = [ "https://claude-code.cachix.org" ];
     trusted-public-keys = [ "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk=" ];
    };

    environment.systemPackages = [
      # For the first build, run with extra-substituters flag to use cache:
      # sudo nixos-rebuild switch --flake .#<hostname> \
      #   --option extra-substituters "https://claude-code.cachix.org" \
      #   --option extra-trusted-public-keys "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
      pkgs.claude-code
    ];

    environment.sessionVariables = {
      
    };
  };
}
