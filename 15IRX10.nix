{
  config,
  pkgs,
  lib,
  inputs,
  kernelOptions,
  ...
}:
let
  kernel = pkgs.linuxPackages_cachyos-lto.cachyOverride kernelOptions;
in
{

  imports = [
    "${inputs.nixos-hardware}/common/cpu/intel/raptor-lake"
    "${inputs.nixos-hardware}/common/gpu/nvidia/prime.nix"
    "${inputs.nixos-hardware}/common/gpu/nvidia/ada-lovelace"
    "${inputs.nixos-hardware}/common/pc/laptop"
    "${inputs.nixos-hardware}/common/pc/ssd"
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];

  services.thermald.enable = lib.mkDefault true;

  hardware = {
    nvidia = {
      package = kernel.nvidiaPackages.beta;
      open = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      modesetting.enable = true;
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
  specialisation.sync = {
    configuration = {
      system.nixos.tags = [ "sync" ];
      hardware.nvidia.prime = {
        offload.enable = lib.mkForce false;
        offload.enableOffloadCmd = lib.mkForce false;
        reverseSync.enable = lib.mkForce false;
        sync.enable = lib.mkForce true;
      };
      hardware.nvidia.powerManagement.finegrained = lib.mkForce false;
    };
  };
  specialisation.reverseSync = {
    configuration = {
      system.nixos.tags = [ "reverse-sync" ];
      hardware.nvidia.prime = {
        offload.enable = lib.mkForce false;
        offload.enableOffloadCmd = lib.mkForce false;
        sync.enable = lib.mkForce false;
        reverseSync.enable = lib.mkForce true;
      };
      hardware.nvidia.powerManagement.finegrained = lib.mkForce false;
    };
  };
}
