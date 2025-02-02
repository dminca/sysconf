let
  bonus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFp8/Py31fozDvpKgvfn2lN5xYOggIo1F90DjxdhEbE5";
  users = [ bonus ];

  artanis = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDM0mEeN9Z7TRf0cnx0Gpkv8at2tl0++Sr1MmxpWIZn";
  kaldir = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlMeDxPYW6dBbDfeCbfpn5UJpPHjyoE7NJQitfuKVPy";
  braxis = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKUkgnjpgtrJOg9oIIsxE8mmmmmc8KsSfirQu+cD4u/n";
  endion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINuVWjxEUNQaP1Ie0p8vj8AEZNPorbwP25MuUmm7j6A/";
  shakuras = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA24tqea9vBJLiTMCgJV7q6UwKHdZAaiL8cUUO5bNd0A";
  zeratul = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP9lpLAJBIP9qSneD5SbfsPp4lMa3xbeldDbWP+UmBiW";
  glacius = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAjgL7ZGbCxc0XG0Lf3FViJLgKwBcaEYFeUrnd8Rroe";
  moria = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMc8a5YtCK/C0cS962UESqvJ9Ap1u/7ipza9p1ah16MQ";
  zhakul = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPO4gx3kfwSmuP5QGhx7M0dMEComlnf4/IWDkj+bkGE";
in
{
  "cloudflare.age".publicKeys = users ++ [ kaldir endion moria zhakul ];
  "cloudflare-tunnel.age".publicKeys = users;
  "cloudflare/keycloak-tunnel.age".publicKeys = users ++ [ braxis ];
  "cloudflare/hedgedoc-tunnel.age".publicKeys = users ++ [ braxis ];
  "cloudflare/taiga-tunnel.age".publicKeys = users ++ [ braxis ];

  "docker-registry-users.age".publicKeys = users ++ [ kaldir ];
  "docker-registry-service-account.age".publicKeys = users;

  "gitea-runner-linux-token.age".publicKeys = users ++ [ shakuras ];

  "matrix-synapse-extra-config.age".publicKeys = users ++ [ kaldir ];
  "matrix-synapse-signing-key.age".publicKeys = users ++ [ kaldir ];
  "matrix-facebook-registration.age".publicKeys = users ++ [ kaldir ];
  "matrix-facebook-environment.age".publicKeys = users ++ [ kaldir ];
  "matrix-telegram-registration.age".publicKeys = users ++ [ kaldir ];
  "matrix-telegram-environment.age".publicKeys = users ++ [ kaldir ];

  "matrix/synapse-extra-config.age".publicKeys = users ++ [ kaldir ];
  "matrix/synapse-signing-key.age".publicKeys = users ++ [ kaldir ];
  "matrix/facebook-registration.age".publicKeys = users ++ [ kaldir ];
  "matrix/facebook-environment.age".publicKeys = users ++ [ kaldir ];
  "matrix/telegram-registration.age".publicKeys = users ++ [ kaldir ];
  "matrix/telegram-environment.age".publicKeys = users ++ [ kaldir ];
  "matrix/googlechat-registration.age".publicKeys = users ++ [ kaldir ];
  "matrix/googlechat-environment.age".publicKeys = users ++ [ kaldir ];
  "matrix/slack-registration.age".publicKeys = users ++ [ kaldir ];
  "matrix/slack-environment.age".publicKeys = users ++ [ kaldir ];

  "nextcloud/admin-pass.age".publicKeys = users ++ [ kaldir ];
  "nextcloud/basic-auth.age".publicKeys = users ++ [ kaldir ];

  "taskwarrior/ca.age".publicKeys = users;
  "taskwarrior/server.age".publicKeys = users;
  "taskwarrior/bonus.age".publicKeys = users ++ [ artanis zeratul ];

  "keycloak-pass.age".publicKeys = users ++ [ braxis ];
  "hedgedoc-env.age".publicKeys = users ++ [ braxis ];
  "discord-bot.age".publicKeys = users ++ [ braxis ];
  "taiga-env.age".publicKeys = users ++ [ braxis ];

  "vector-dev.age".publicKeys = users ++ [ kaldir braxis endion shakuras glacius moria zhakul ];
  "telegraf-mqtt-env.age".publicKeys = users ++ [ kaldir ];

  "obsidian-env.age".publicKeys = users ++ [ kaldir ];

  "wifi.age".publicKeys = users ++ [ artanis ];
}
