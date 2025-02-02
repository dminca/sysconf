{ config, ... }:
{
  age.secrets.hedgedoc-env = {
    file = ../../secrets/hedgedoc-env.age;
    mode = "0440";
    group = "hedgedoc";
  };

  age.secrets.hedgedocPass = {
    file = ../../secrets/cloudflare/hedgedoc-tunnel.age;
    mode = "0440";
    group = "cloudflared";
  };

  services.cloudflared.tunnels."3ebda45f-5c0b-4d17-a6fb-6f1d7d3f1d4c" = {
    credentialsFile = config.age.secrets.hedgedocPass.path;
    default = "http_status:404";
    ingress = {
      "md.kncyber.pl" = {
        service = "http://localhost:3010";
      };
    };
  };

  services.hedgedoc = {
    enable = true;
    environmentFile = config.age.secrets.hedgedoc-env.path;
    settings = {
      db = {
        dialect = "sqlite";
        storage = "/var/lib/hedgedoc/db.hedgedoc.sqlite";
      };
      domain = "md.kncyber.pl";
      protocolUseSSL = true;
      port = 3010;

      oauth2 = {
        userProfileURL = "https://keycloak.kncyber.pl/realms/leaks/protocol/openid-connect/userinfo";
        userProfileUsernameAttr = "preferred_username";
        userProfileEmailAttr = "email";
        userProfileDisplayNameAttr = "preferred_username";
        tokenURL = "https://keycloak.kncyber.pl/realms/leaks/protocol/openid-connect/token";
        authorizationURL = "https://keycloak.kncyber.pl/realms/leaks/protocol/openid-connect/auth";
        providerName = "Keycloak";
        clientSecret = "$OAUTH2_SECRET";
        clientID = "hedgedoc";
        scope = "openid email profile";
      };

      # disable email signup
      email = false;
      allowEmailRegister = false;

      # security
      allowFreeURL = false;
      allowAnonymousEdits = false;
      allowAnonymous = false;
      defaultPermission = "limited";
      requireFreeURLAuthentication = true;

      documentMaxLength = 10000000;
    };
  };
}
