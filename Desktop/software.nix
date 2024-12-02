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
    # Connectivity
    nmap
    libcec
    clinfo
    #alfis

    dfu-util
    dfu-programmer
    hackrf

    #growisofs

    rocmPackages.rocm-smi
    rocmPackages.rocminfo


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
    cool-retro-term
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
    #qtox
    dino
    gomuks
    deltachat-desktop

    # Games
    #steam
    steam-run-native
    openttd
    #minecraft
    minetest
    vulkan-tools
    wineWowPackages.stable
    winetricks
    protontricks
    xonotic
    # cataclysm-dda

    sidequest
    lutris

    # VCS
    git
    gitAndTools.git-bug
    git-cliff

    # IDE
    inex-vscode.packages.x86_64-linux.default
    (pkgs.callPackage ./modules/my_vim.nix { })
    android-studio

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
    nil
    go
    hugo

    # Docker and orchestration
    ansible
    docker-compose

    cookiecutter

    # Maps
    josm

    # Screen recording
    obs-studio
    gpu-screen-recorder-gtk
    kooha

    # Graphics
    krita
    potrace
    ffmpeg
    #blender-hip
    shotwell
    inkscape
    kdenlive
    davinci-resolve
    libheif
    digikam

    # Audio
    audacity
    # lmms
    picard
    # cmus
    #spotify
    easyeffects
    #clementine
    #vlc
    # syncplay
    mpv

    #ylibsForQt5.k3b

    # DAW
    # zrythm
    # distrho
    helvum
    zam-plugins
    x42-plugins
    helm
    zyn-fusion
    #lsp-plugins
    ardour
    # Documents
    #anki
    libreoffice
    klavaro
    liberation_ttf
    keepassxc
    glow
    obsidian
    aegisub
    texlive.combined.scheme-full
    archi

    # iPhone passthru
    usbmuxd
    socat

    zotero

    timewarrior
  ];

}
