{ config, lib, ... }:
{
  _file = ./treesitter.nix;
  config.plugins.treesitter = lib.mkIf config.nvchad.enable {
    enable = lib.mkDefault true;
    settings = {
      auto_install = lib.mkDefault false;
      ensure_installed = [ "lua" "luadoc" "printf" "vim" "vimdoc" ];

      highlight = {
        enable = lib.mkDefault true;
        use_languagetree = lib.mkDefault true;
      };

      indent = { enable = lib.mkDefault true; };
    };
    luaConfig.pre = # lua
    ''
      pcall(function()
        dofile(vim.g.base46_cache .. "syntax")
        dofile(vim.g.base46_cache .. "treesitter")
      end)
    '';
  };
}
