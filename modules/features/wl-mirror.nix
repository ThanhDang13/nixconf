{ ... }: {
  flake.nixosModules.wl-mirror = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      wl-mirror

      (writeShellScriptBin "mirror-display" ''
        exec ${wl-mirror}/bin/wl-mirror \
          --fullscreen-output HDMI-A-1 \
          eDP-1
      '')
    ];
  };
}