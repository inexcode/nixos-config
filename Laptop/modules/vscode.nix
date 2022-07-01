{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
  extensions = (with pkgs.vscode-extensions; [
    unstable.vscode-extensions.ms-vsliveshare.vsliveshare
    arcticicestudio.nord-visual-studio-code
    bbenoist.nix
    davidanson.vscode-markdownlint
    dbaeumer.vscode-eslint
    jakebecker.elixir-ls
    james-yu.latex-workshop
    jnoortheen.nix-ide
    mhutchie.git-graph
    ms-azuretools.vscode-docker
    ms-python.vscode-pylance
    ms-python.python
    ms-toolsai.jupyter
    ms-vscode-remote.remote-ssh
    ms-vscode.cpptools
    github.copilot
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "vscode-standardjs";
      publisher = "chenxsan";
      version = "1.4.1";
      sha256 = "0hiaqflp0d3k2pq3p44wrpyn4v6n0x660f4v47nf9bsdn5lidih3";
    }
    {
      name = "npm-intellisense";
      publisher = "christian-kohler";
      version = "1.4.1";
      sha256 = "0hph57g8fbwrvj1sdzc7vqsiaf7n2qzvkakc9ir0kkkwwdxc6c5a";
    }
    {
      name = "dart-code";
      publisher = "Dart-Code";
      version = "3.40.0";
      sha256 = "1cvibhazgz42zzwlk354sihrimw26qvgsq5nirvwx4v27gcirq81";
    }
    {
      name = "flutter";
      publisher = "Dart-Code";
      version = "3.40.0";
      sha256 = "0yxkqr6ajpdl06rxxad4c1zx5ci4sbaj2lk2xl9bws51imn58wry";
    }
    {
      name = "vscode-html-css";
      publisher = "ecmel";
      version = "1.12.2";
      sha256 = "059s1yg0b875b3ijhwgpg8v408as5z6r876jv5jing1vjb20pgvb";
    }
    {
      name = "vscode-npm-script";
      publisher = "eg2";
      version = "0.3.25";
      sha256 = "0z01i0fhl0phmz5bx5fh80flarldk7sdqgr14vx9kjz5yjzz48ys";
    }
    {
      name = "vsc-material-theme-icons";
      publisher = "equinusocio";
      version = "2.3.1";
      sha256 = "1djm4k3hcn4aq63d4mxs2n4ffq5x1qr82q6gxwi5pmabrb0hrb30";
    }
    {
      name = "vscode-systemd-support";
      publisher = "hangxingliu";
      version = "1.0.1";
      sha256 = "0f7j6y1jngicm475nilx08j55d94nnmymifxcbkszlxg0lnjrqys";
    }
    {
      name = "materialdesignicons-intellisense";
      publisher = "lukas-tr";
      version = "4.0.0";
      sha256 = "1748pj3jcgddpiamcs4ii2bjsmn9m9fx0dn2swfki8c6ibwrhy0w";
    }
    {
      name = "remote-containers";
      publisher = "ms-vscode-remote";
      version = "0.234.0";
      sha256 = "07mx08nwvw7jdlvkbr5iwikrcriib4zc1im1lbrqxjv7paj1an86";
    }

  ];
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };

in
{
  config = {
    environment.systemPackages = [
      vscode-with-extensions
    ];
  };
}
