{ config, pkgs, lib, ... }:

with lib;

let
  dataDir = "/var/lib/mautrix-googlechat";
  registrationFile = "${dataDir}/googlechat-registration.yaml";
  cfg = config.services.mautrix-googlechat;
  settingsFormat = pkgs.formats.json {};
  settingsFile = settingsFormat.generate "mautrix-googlechat-config.json" cfg.settings;
in {
  options = {
    services.mautrix-googlechat = {
      enable = mkEnableOption (lib.mdDoc "A Matrix-Google Chat puppeting bridge");

      settings = mkOption rec {
        apply = recursiveUpdate default;
        inherit (settingsFormat) type;
        default = {
          homeserver = {
            software = "standard";
          };

          appservice = rec {
            database = "sqlite:///${dataDir}/mautrix-googlechat.db";
            database_opts = {};
            hostname = "0.0.0.0";
            port = 8080;
            address = "http://localhost:${toString port}";
          };

          bridge = {
            double_puppet_server_map = {};
            login_shared_secret_map = {};
          };

          logging = {
            version = 1;

            formatters.precise.format = "[%(levelname)s@%(name)s] %(message)s";

            handlers.console = {
              class = "logging.StreamHandler";
              formatter = "precise";
            };

            loggers = {
              mau.level = "INFO";
              telethon.level = "INFO";

              # prevent tokens from leaking in the logs:
              # https://github.com/tulir/mautrix-telegram/issues/351
              aiohttp.level = "WARNING";
            };

            # log to console/systemd instead of file
            root = {
              level = "INFO";
              handlers = [ "console" ];
            };
          };
        };
        example = literalExpression ''
          {
            homeserver = {
              address = "http://localhost:8008";
              domain = "public-domain.tld";
            };

            appservice.public = {
              prefix = "/public";
              external = "https://public-appservice-address/public";
            };

            bridge.permissions = {
              "example.com" = "full";
              "@admin:example.com" = "admin";
            };
          }
        '';
        description = lib.mdDoc ''
          {file}`config.yaml` configuration as a Nix attribute set.
          Configuration options should match those described in
          [example-config.yaml](https://github.com/mautrix/googlechat/blob/master/mautrix_googlechat/example-config.yaml).

          Secret tokens should be specified using {option}`environmentFile`
          instead of this world-readable attribute set.
        '';
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          File containing environment variables to be passed to the mautrix-googlechat service,
          in which secret tokens can be specified securely by defining values for e.g.
          `MAUTRIX_GOOGLECHAT_APPSERVICE_AS_TOKEN`,
          `MAUTRIX_GOOGLECHAT_APPSERVICE_HS_TOKEN`,
          `MAUTRIX_GOOGLECHAT_GOOGLECHAT_API_ID`,
          `MAUTRIX_GOOGLECHAT_GOOGLECHAT_API_HASH` and optionally
          `MAUTRIX_GOOGLECHAT_GOOGLECHAT_BOT_TOKEN`.

          These environment variables can also be used to set other options by
          replacing hierarchy levels by `.`, converting the name to uppercase
          and prepending `MAUTRIX_GOOGLECHAT_`.
          For example, the first value above maps to
          {option}`settings.appservice.as_token`.

          The environment variable values can be prefixed with `json::` to have
          them be parsed as JSON. For example, `login_shared_secret_map` can be
          set as follows:
          `MAUTRIX_GOOGLECHAT_BRIDGE_LOGIN_SHARED_SECRET_MAP=json::{"example.com":"secret"}`.
        '';
      };

      serviceDependencies = mkOption {
        type = with types; listOf str;
        default = optional config.services.matrix-synapse.enable "matrix-synapse.service";
        defaultText = literalExpression ''
          optional config.services.matrix-synapse.enable "matrix-synapse.service"
        '';
        description = lib.mdDoc ''
          List of Systemd services to require and wait for when starting the application service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mautrix-googlechat = {
      description = "A Matrix-Google Chat puppeting bridge";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;
      path = [ pkgs.lottieconverter pkgs.ffmpeg-full ];

      # mautrix-googlechat tries to generate a dotfile in the home directory of
      # the running user if using a postgresql database:
      #
      #  File "python3.10/site-packages/asyncpg/connect_utils.py", line 257, in _dot_postgre>
      #    return (pathlib.Path.home() / '.postgresql' / filename).resolve()
      #  File "python3.10/pathlib.py", line 1000, in home
      #    return cls("~").expanduser()
      #  File "python3.10/pathlib.py", line 1440, in expanduser
      #    raise RuntimeError("Could not determine home directory.")
      # RuntimeError: Could not determine home directory.
      environment.HOME = dataDir;

      preStart = ''
        # generate the appservice's registration file if absent
        if [ ! -f '${registrationFile}' ]; then
          ${pkgs.mautrix-googlechat}/bin/mautrix-googlechat \
            --generate-registration \
            --base-config='${pkgs.mautrix-googlechat}/share/mautrix-googlechat/example-config.yaml' \
            --config='${settingsFile}' \
            --registration='${registrationFile}'
        fi
      '' + lib.optionalString (pkgs.mautrix-googlechat ? alembic) ''
        # run automatic database init and migration scripts
        ${pkgs.mautrix-googlechat.alembic}/bin/alembic -x config='${settingsFile}' upgrade head
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        DynamicUser = true;
        PrivateTmp = true;
        WorkingDirectory = pkgs.mautrix-googlechat; # necessary for the database migration scripts to be found
        StateDirectory = baseNameOf dataDir;
        UMask = "0027";
        EnvironmentFile = cfg.environmentFile;

        ExecStart = ''
          ${pkgs.mautrix-googlechat}/bin/mautrix-googlechat \
            --config='${settingsFile}'
        '';
      };
    };
  };

  #meta.maintainers = with maintainers; [ pacien vskilet ];
}
