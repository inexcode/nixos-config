{ config, pkgs, ... }:

{
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    # interactiveShellInit = "ponysay -q";
    autosuggestions = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "python"
        "man"
        "z"
        "catimg"
        "copyfile"
        "encode64"
        "extract"
        "npm"
        "pip"
      ];
      theme = "spaceship";
      customPkgs = with pkgs; [
        pkgs.nix-zsh-completions
        pkgs.spaceship-prompt
        pkgs.zsh-autosuggestions
        pkgs.zsh-syntax-highlighting
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
}
