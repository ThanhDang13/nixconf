{ self , inputs, ... }: {

  flake.nixosModules.snix-gpu = { config, pkgs, ... }: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "fbcon=nodefer"
      "amdgpu.dc=1"
    ];

    services.xserver.videoDrivers = [ "nvidia" "amdgpu"];

    systemd.services.display-manager = {        
      after = [ "systemd-udev-settle.service" ];
      wants = [ "systemd-udev-settle.service" ];
    };
  
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

}
