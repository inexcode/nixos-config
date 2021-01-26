{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in {
  environment.systemPackages = with pkgs; [
    # Utils    
    pciutils
    usbutils
    i2c-tools
    lm_sensors
    bind
    nix-bundle
    file
    restic

    # Connectivity
    nmap
    libcec

    # File systems
    gparted

    # Archives
    unzip
    unrar

    # Running things
    appimage-run

    # Manuals
    unstable.manix
    tldr

    # Terminal
    cool-retro-term
    mosh
    tmux
    neofetch
    ponysay
    bpytop

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
    ungoogled-chromium
    unstable.tor-browser-bundle-bin

    # Downloaders
    transmission-gtk
    youtube-dl
    syncthing
    wget

    # Messangers
    tdesktop
    #discord
    mumble
    #riot-desktop
    qtox
    dino
    #zoom-us
    #teams
    teamspeak_client
    
    # Games
    steam
    steam-run-native
    openttd
    minecraft
    vulkan-tools
    wineWowPackages.full
    wineWowPackages.fonts
    winetricks
    xonotic
    
    # VCS
    git
    gitAndTools.git-bug

    # IDE
    vscode
    (pkgs.callPackage ./modules/my_vim.nix {})

    # Compilers and interpretators
    ccls
    cmake
    gcc-unwrapped
    octaveFull
    texlive.combined.scheme-full
    python3Full
    nodejs
    fdroidserver

    # Docker and orchestration
    ansible_2_9
    docker-compose
    
    # Maps
    josm
    
    # Screen recording
    unstable.obs-studio
    unstable.obs-wlrobs
    unstable.obs-v4l2sink
    #unstable.obs-linuxbrowser
    peek
    
    # Graphics
    krita
    gmic_krita_qt
    potrace
    ffmpeg
    
    # Audio
    audacity
    # lmms
    picard
    cmus
    spotify
    pulseeffects

    vlc
    syncplay

    kruler

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
    glow
    
    # Themes
    paper-icon-theme
    plata-theme
    
  ];

}
