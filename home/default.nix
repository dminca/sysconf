{ pkgs, nixpkgs-unstable, ... }:
{
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./git.nix
    ./gpg.nix
    ./nix-index.nix
    ./pass.nix
    ./ssh.nix
    ./sway.nix
    ./tmux.nix
  ];

  home.packages = (with pkgs; [
    (import ./neovim.nix pkgs)
    imv
    htop
    vlc
    pavucontrol
    p7zip
    wireshark
    thunderbird
    zathura
    ripgrep
    jq
    whois
    (python3.withPackages (packages: with packages; [
      ipython
      pwntools
    ]))
    man-pages
    man-pages-posix
    bitwarden
    waybar
    git
    qt5.qtwayland
    qt6.qtwayland
    blender
    yt-dlp
    kicad
    docker-compose
    slack
    pass
    file
    gimp
    magic-wormhole
    kubectl
    kubectx
    wireguard-tools
    gef
    gdb
    mtr
    iotop
    iftop
    nfs-utils
    openssl
    bridge-utils
    taskwarrior
    taskwarrior-tui
    nmap
    hexyl
    firefox-wayland
    mattermost-desktop
    element-desktop
    libreoffice
    discord
  ]) ++ (with nixpkgs-unstable; [
    imhex
    tor-browser-bundle-bin
    ghidra-bin
    signal-desktop
    virt-manager
  ]);
}
