{ self, inputs, ... }: {

  flake.nixosConfigurations.snix = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.snix-configuration
    ];
  };

}
