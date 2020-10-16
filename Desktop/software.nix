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
    i2c-tools
    lm_sensors
    bind
    libcec
    # openvpn
    git
    unzip
    tldr
    ffmpeg
    wget
    nix-bundle
    nmap
    file
    unrar
    mosh
    syncthing

    # ROCm
    rocm-opencl-runtime
    rocm-smi
    clinfo

    # Voice
    speechd
    rhvoice

    # Wireguard
    #wireguard
    #wireguard-tools

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
    #qtox
    dino
    zoom-us
    teams
    teamspeak_client
    
    # Games
    steam
    steam-run-native
    openttd
    minecraft
    unstable.lutris-unwrapped
    vulkan-tools
    wineWowPackages.full
    wineWowPackages.fonts
    winetricks
    xonotic
    
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
    unstable.obs-studio
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
    spotify

    vlc

    # Plugins
    # ladspaPlugins
    # lsp-plugins
    
    # Documents
    anki
    libreoffice
    homebank
    trilium-desktop
    klavaro
    liberation_ttf
    keepassxc
    
    # Themes
    paper-icon-theme
    plata-theme
    
  ];

}
