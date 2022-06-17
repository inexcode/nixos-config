{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
  MyOBS = pkgs.wrapOBS.override { obs-studio = pkgs.obs-studio; } {
  plugins = with pkgs.obs-studio-plugins; [
    wlrobs
    obs-gstreamer
        obs-multi-rtmp
  ];
};
in
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
    alfis

    # File systems
    gparted
    btrfs-progs

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
    httpie
    htop

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
    syncthing
    wget
    yt-dlp

    # Messangers
    tdesktop
    mumble
    qtox
    dino
    gomuks
    deltachat-desktop

    # Games
    steam
    steam-run-native
    openttd
    minecraft
    vulkan-tools
    wineWowPackages.stable
    winetricks
    protontricks
    xonotic
    cataclysm-dda

    lutris
    bottles

    # VR
    monado
    openhmd

    # VCS
    git
    gitAndTools.git-bug

    # IDE

    (pkgs.callPackage ./modules/my_vim.nix { })
    lens
    postman
    androidStudioPackages.canary

    # Compilers and interpretators
    ccls
    cmake
    gcc-unwrapped
    octaveFull
    python3Full
    nodejs
    nixpkgs-fmt
    pandoc

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
    gmic_krita_qt
    potrace
    ffmpeg
    blender
    unstable.shotwell
    inkscape
    kdenlive

    # Audio
    audacity
    # lmms
    picard
    cmus
    spotify
    pulseeffects-pw

    vlc
    syncplay
    mpv

    brasero
    libsForQt5.k3b

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
    homebank
    klavaro
    liberation_ttf
    keepassxc
    glow
    unstable.obsidian
    aegisub

    # Themes
    paper-icon-theme
    plata-theme

  ];

}
