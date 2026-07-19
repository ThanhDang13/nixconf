{ self, inputs, ... }: {

 flake.nixosModules.snix-configuration = { pkgs, lib, ... }: {
   imports = [
     self.nixosModules.snix-hardware
     self.nixosModules.snix-gpu
     self.nixosModules.niri
     self.nixosModules.chrome
     self.nixosModules.vscodium
     self.nixosModules.kitty
     self.nixosModules.rog
     self.nixosModules.sddm
     self.nixosModules.zsh
     self.nixosModules.fcitx5
     self.nixosModules.discord
     self.nixosModules.docker
     self.nixosModules.nautilus
   ];

   environment.systemPackages = with pkgs; [
   ];

   security.sudo.enable = true;

   time.timeZone = "Asia/Ho_Chi_Minh";
   time.hardwareClockInLocalTime = true;

   users.users.sakata = {
     isNormalUser = true;
     extraGroups = [ 
      "video" 
      "render" 
      "input" 
      "wheel" 
      "networkmanager"
      "docker"
      ];
   };

   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   nixpkgs.config.allowUnfree = true;

   boot.kernelPackages = pkgs.linuxPackages_latest;
   boot.loader = {
     systemd-boot.enable = lib.mkForce false;
     grub = {
       enable = true;
       efiSupport = true;
       device = "nodev";
       useOSProber = true;
     };
     efi = {
       efiSysMountPoint = "/boot/efi";
       canTouchEfiVariables = true;
     };
   };

   networking.networkmanager.enable = true;

   hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
   };

   zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;  
    priority = 100;
  };

  swapDevices = [
    {
      device = "/var/swapfile";
      size = 4096;  
    }
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 60;
  };

   system.stateVersion = "26.05";
 };

}
