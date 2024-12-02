{ config, pkgs, inex-vscode, ... }:

{
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
    jq
    sbctl
    # Connectivity
    nmap
    libcec
    clinfo
    #alfis


    # File systems
    gparted
    btrfs-progs

    # Archives
    unzip
    unrar

    # Running things
    appimage-run

    # Manuals
    manix
    tldr

    # Terminal
    mosh
    tmux
    neofetch
    ponysay
    btop
    httpie
    htop

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
    tor-browser-bundle-bin

    # Downloaders
    transmission_4-gtk
    syncthing
    wget
    yt-dlp

    # Messangers
    tdesktop
    mumble
    dino
    gomuks
    deltachat-desktop

    wineWowPackages.stable
    winetricks

    # VCS
    git
    gitAndTools.git-bug

    # IDE
    inex-vscode.packages.x86_64-linux.default
    android-studio
    arduino-ide

    # Compilers and interpretators
    ccls
    cmake
    gcc-unwrapped
    octaveFull
    python3Full
    nodejs
    nixpkgs-fmt
    pandoc
    racket
    dart

    go
    #hugo

    # Docker and orchestration
    ansible
    docker-compose

    cookiecutter

    # Maps
    josm

    # Screen recording
    obs-studio
    kooha

    # Graphics
    krita
    potrace
    ffmpeg
    #blender-hip
    inkscape
    kdenlive
    libheif

    # Audio
    audacity
    # lmms
    picard
    easyeffects
    mpv

    steam-run

    # Documents
    libreoffice
    klavaro
    liberation_ttf
    keepassxc
    glow
    obsidian
    aegisub
    # texlive.combined.scheme-full

    # Themes
    paper-icon-theme
    plata-theme

    # iPhone passthru
    usbmuxd
    socat

    zotero
    virt-manager

    immersed-vr

    godot_4
  ];

}
