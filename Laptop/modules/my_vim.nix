{neovim, vimUtils, vimPlugins, stdenv, fetchgit}:

let custom_config=''
let g:airline_powerline_fonts = 1
let g:airline_theme='dark'
'';
in neovim.override {
 vimAlias = true;
 configure = {
   customRC = custom_config;
   vam.pluginDictionaries = [
   { names = [
         "vim-sensible"
         "vim-airline"
         "vim-airline-themes"
         "nerdtree"
         "vim-nix"
         "dart-vim-plugin"
       ];
     }
   ];
 };
}

