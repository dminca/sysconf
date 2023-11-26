{ config, lib, ... }:
{
  custom.traefik.entries = [
    {
      name = "plex";
      domain = "plex.mlwr.dev";
      port = 32400;
      target = config.containers.plex.localAddress;
      entrypoints = [ "warps" ];
    }
  ];

  containers.plex = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "172.28.1.1";
    localAddress = "172.28.1.2";
    bindMounts = {
      "/storage" = {
        hostPath = "/storage";
        isReadOnly = true;
      };
    };

    config = { config, lib, ... }: {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "plexmediaserver"
      ];

      services.plex.enable = true;

      networking = {
        interfaces.eth0.useDHCP = true;
        firewall.enable = true;
      };

      system.stateVersion = "23.05";
    };
  };
}
