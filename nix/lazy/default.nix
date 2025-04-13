{ config, lib, ... }:
{
  _file = ./.;
  imports = [
    ./plugins.nix
    ./nvchad.nix
    ./cmp.nix
  ];
  config = lib.mkIf config.nvchad.enable {
    plugins.lazy.enable = true;
    plugins.lazy.extraParams = {
      defaults = { lazy = true; };
      install = { colorscheme = [ "nvchad" ]; };

      ui = {
        icons = {
          ft = "";
          lazy = "󰂠 ";
          loaded = "";
          not_loaded = "";
        };
      };

      performance = {
        rtp = {
          disabled_plugins = [
            "2html_plugin"
            "tohtml"
            "getscript"
            "getscriptPlugin"
            "gzip"
            "logipat"
            "netrw"
            "netrwPlugin"
            "netrwSettings"
            "netrwFileHandlers"
            "matchit"
            "tar"
            "tarPlugin"
            "rrhelper"
            "spellfile_plugin"
            "vimball"
            "vimballPlugin"
            "zip"
            "zipPlugin"
            "tutor"
            "rplugin"
            "syntax"
            "synmenu"
            "optwin"
            "compiler"
            "bugreport"
            "ftplugin"
          ];
        };
      };
    };
  };
}
