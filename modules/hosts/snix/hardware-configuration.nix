{ self, inputs, ... }: {

  flake.nixosModules.snix-hardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [ 
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/91fc4a3e-1c84-4c1f-9084-dc8b923f477b";
        fsType = "ext4";
      };

    fileSystems."/boot/efi" =
      { device = "/dev/disk/by-uuid/FCA0-E800";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };

    swapDevices = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

}
