{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.sNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings = (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;
    };
  };
}