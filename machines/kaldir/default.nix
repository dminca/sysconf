{ lib, config, pkgs, nixpkgs-unstable, home-manager, ... }:
{
  imports = [
    ./docker-registry.nix
    ./grafana.nix
    ./hardware-configuration.nix
    ./loki.nix
    ./networking.nix
    ./tailscale.nix
    ./prometheus.nix
    ./taskserver.nix
    ./traefik.nix
    ./matrix-synapse.nix
    ./matrix-facebook.nix
    ./matrix-telegram.nix
    ./matrix-irc.nix
    ./matrix-googlechat.nix
    #./matrix-slack.nix
    ./mosquitto.nix
    ./ghidra.nix
    ./influx.nix
    ./nextcloud.nix
    ./hedgedoc.nix
  ];

  custom = {
    base.enable = true;
    server = {
      enable = true;
      vm = false;
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 5;
    };
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };

  services.fwupd.enable = true;
}
