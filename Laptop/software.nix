{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Utils    
    cool-retro-term
    tmux
    ponysay
    neovim
    neofetch
    pciutils
    openvpn
    git

    # Encrypted folders
    encfs
    gencfsm

    # Browsers
    firefox

    # Messangers
    tdesktop
    discord
    riot-desktop
    
    # Games
    steam
    openttd
    lutris-unwrapped
    
    # Development
    vscode
    ansible
    octaveFull
    texlive.combined.scheme-full
    gcc-unwrapped
    python3Full
    
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
    
    # Documents
    anki
    libreoffice
  ];
}

