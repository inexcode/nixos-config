{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in
{
  environment.systemPackages = with pkgs; [
    # Utils
    (pkgs.callPackage ./modules/my_vim.nix { })
    pciutils
    usbutils
    i2c-tools
    bind
    nix-bundle
    file
    glxinfo

    nmap

    gparted

    # Archives
    unzip
    unrar

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
    httpie
    htop

    # Voice
    speechd
    rhvoice
    unstable.noisetorch

    xsane

    # Wireguard
    wireguard-tools

    nextcloud-client

    # Encrypted folders
    encfs
    #gencfsm

    # Browsers
    firefox
    ungoogled-chromium

    # Downloaders
    transmission-gtk
    yt-dlp
    syncthing
    wget

    # Messangers
    tdesktop
    mumble
    qtox
    dino
    gomuks

    # Games
    steam
    steam-run
    unstable.openttd
    minecraft
    lutris
    vulkan-tools
    wineWowPackages.full
    wineWowPackages.fonts
    xonotic
    cataclysm-dda

    # VCS
    git
    gitAndTools.git-bug

    # IDE
    lens
    postman
    unstable.androidStudioPackages.canary

    # Compilers and interpretators
    ccls
    cmake
    gcc-unwrapped
    octaveFull
    python3Full
    nodejs
    nixpkgs-fmt

    # Docker and orchestration
    ansible
    docker-compose

    # Maps
    josm

    # Screen recording
    obs-studio
    peek

    # Graphics
    blender
    krita
    gmic_krita_qt
    potrace
    ffmpeg
    inkscape
    imagemagick

    # Audio
    audacity
    pulseeffects-pw
    # lmms
    picard
    cmus
    spotify
    rhythmbox
    unstable.helvum

    vlc
    syncplay

    # DAW
    zrythm
    distrho
    helvum
    zam-plugins
    x42-plugins
    helm
    zyn-fusion
    lsp-plugins
    ardour

    # Documents
    anki
    libreoffice
    liberation_ttf
    obsidian
    keepassxc
    glow
  ];

}
