{ lib, config, pkgs, home-manager, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./gitea.nix
  ];

  custom = {
    base.enable = true;
    server = {
      enable = true;
      vm = true;
    };
    traefik = {
      enable = true;
      warpIP = "100.99.52.31";
    };
    warp-net.enable = true;
    monitoring.enable = true;
  };

  boot = {
    loader.grub.device = "/dev/sda";
    tmp.useTmpfs = true;
    tmp.cleanOnBoot = true;
  };

  networking.hostName = "endion";
}
