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
    openvpn
    git
    unzip
    tldr
    ffmpeg

    nextcloud-client

    # Encrypted folders
    encfs
    gencfsm

    # Browsers
    firefox
    transmission-gtk

    # Messangers
    tdesktop
    discord
    riot-desktop
    qtox
    
    # Games
    steam
    steam-run-native
    unstable.openttd
    vulkan-tools
    lutris-unwrapped
    
    # Development
    vscode
    ansible
    octaveFull
    texlive.combined.scheme-full
    gcc-unwrapped
    python3Full
    #android-studio
    cmake

    josm
    
    # Screen recording
    obs-studio
    peek
    
    # Graphics
    krita
    gmic_krita_qt
    
    # Audio
    audacity
    lmms
    picard
    cmus

    # Plugins
    ladspaPlugins
    lsp-plugins
    
    # Documents
    anki
    libreoffice
    homebank
  ];
}

