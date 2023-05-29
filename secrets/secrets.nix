let
  bonus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFp8/Py31fozDvpKgvfn2lN5xYOggIo1F90DjxdhEbE5";
  users = [ bonus ];

  artanis = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDM0mEeN9Z7TRf0cnx0Gpkv8at2tl0++Sr1MmxpWIZn";
  kaldir = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlMeDxPYW6dBbDfeCbfpn5UJpPHjyoE7NJQitfuKVPy";
  braxis = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKUkgnjpgtrJOg9oIIsxE8mmmmmc8KsSfirQu+cD4u/n";
  endion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINuVWjxEUNQaP1Ie0p8vj8AEZNPorbwP25MuUmm7j6A/";
  shakuras = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA24tqea9vBJLiTMCgJV7q6UwKHdZAaiL8cUUO5bNd0A";

  systems = [ artanis kaldir braxis ];
in
{
  "cloudflare.age".publicKeys = users ++ [ kaldir ];
  "cloudflare-tunnel.age".publicKeys = users;

  "docker-registry-users.age".publicKeys = users ++ [ kaldir ];
  "docker-registry-service-account.age".publicKeys = users;

  "gitea-runner-linux-token.age".publicKeys = users ++ [ shakuras ];

  "matrix-synapse-extra-config.age".publicKeys = users ++ [ kaldir ];
  "matrix-synapse-signing-key.age".publicKeys = users ++ [ kaldir ];
  "matrix-facebook-registration.age".publicKeys = users ++ [ kaldir ];
  "matrix-facebook-environment.age".publicKeys = users ++ [ kaldir ];
  "matrix-telegram-registration.age".publicKeys = users ++ [ kaldir ];
  "matrix-telegram-environment.age".publicKeys = users ++ [ kaldir ];

  "keycloak-pass.age".publicKeys = users ++ [ braxis ];
  "keycloak-tunnel.age".publicKeys = users ++ [ braxis ];
  "hedgedoc-tunnel.age".publicKeys = users ++ [ braxis ];
  "hedgedoc-env.age".publicKeys = users ++ [ braxis ];
  "discord-bot.age".publicKeys = users ++ [ braxis ];
  "taiga-secrets.age".publicKeys = users ++ [ braxis ];

  "wifi.age".publicKeys = users ++ [ artanis ];
}
