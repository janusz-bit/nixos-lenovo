{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{

  imports = [
    "${inputs.nixos-hardware}/common/cpu/intel/raptor-lake"
    "${inputs.nixos-hardware}/common/gpu/nvidia/prime.nix"
    "${inputs.nixos-hardware}/common/gpu/nvidia/ada-lovelace"
    "${inputs.nixos-hardware}/common/pc/laptop"
    "${inputs.nixos-hardware}/common/pc/ssd"
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        # nvidia-vaapi-driver
        intel-media-driver # Recommended only with Intel iGPU
      ];
    };
    nvidia = {
      open = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      modesetting.enable = true; # Mandatory for Wayland

      package = config.boot.kernelPackages.nvidiaPackages.production;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";

      };
    };
  };

  specialisation = {
    gaming-time.configuration = {

      hardware.nvidia = {
        prime.sync.enable = lib.mkForce true;
        prime.offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };

    };
  };
}
