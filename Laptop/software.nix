{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in {
  environment.systemPackages = with pkgs; [
    # Utils    
    cool-retro-term
    tmux
    ponysay
    (pkgs.callPackage ./modules/my_vim.nix {})
    neofetch
    pciutils
    usbutils
    bind
    # openvpn
    git
    unzip
    tldr
    ffmpeg
    wget
    nix-bundle
    nmap

    # Wireguard
    wireguard
    wireguard-tools

    nextcloud-client

    # Encrypted folders
    encfs
    #gencfsm

    # Browsers
    firefox
    transmission-gtk
    youtube-dl

    # Messangers
    tdesktop
    #discord
    mumble
    #riot-desktop
    qtox
    dino
    zoom-us
    
    # Games
    steam
    steam-run-native
    unstable.openttd
    lutris
    vulkan-tools
    wineWowPackages.full
    wineWowPackages.fonts
    
    # Development
    vscode
    ansible
    octaveFull
    texlive.combined.scheme-full
    gcc-unwrapped
    python3Full
    # (import (builtins.fetchTarball "https://github.com/babariviere/nixpkgs/archive/flutter-init.tar.gz") {}).flutter
    #android-studio
    cmake
    nodejs

    ccls

    josm
    
    # Screen recording
    obs-studio
    peek
    
    # Graphics
    krita
    gmic_krita_qt
    potrace
    
    # Audio
    audacity
    # lmms
    picard
    cmus

    # Plugins
    # ladspaPlugins
    # lsp-plugins
    
    # Documents
    anki
    libreoffice
    homebank
    trilium
    klavaro
    liberation_ttf
  ];
}

