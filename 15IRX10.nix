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

  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];

  services.thermald.enable = lib.mkDefault true;

  hardware = {
    nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";

      };
    };
  };
}
