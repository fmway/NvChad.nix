{ pkgs, nixvimLib, config, lib, ... }: let
  inherit (nixvimLib) helpers;
  inherit (helpers) mkLuaFn;
  inConfig = name:
    helpers.toLuaObject (import (./configs + "/${name}.nix") { inherit pkgs helpers inConfig; });
in {
  _file = ./plugins.nix;
  config = lib.mkIf config.nvchad.enable {
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      plenary-nvim
      {
        pkg = nvim-web-devicons;
        opts.__raw = mkLuaFn /* lua */ ''
          dofile(vim.g.base46_cache .. "devicons")
          return { override = require "nvchad.icons.devicons" }
        '';
      }
      {
        pkg = indent-blankline-nvim-lua;
        event = "User FilePost";
        opts = {
          indent = { char = "│"; highlight = "IblChar"; };
          scope = { char = "│"; highlight = "IblScopeChar"; };
        };
        config.__raw = mkLuaFn [ "_" "opts" ] /* lua */ ''
          dofile(vim.g.base46_cache .. "blankline")

          local hooks = require "ibl.hooks"
          hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
          require("ibl").setup(opts)

          dofile(vim.g.base46_cache .. "blankline")
        '';
      }

      # file managing , picker etc
      {
        pkg = nvim-tree-lua;
        cmd = [ "NvimTreeToggle" "NvimTreeFocus" ];
        opts.__raw = mkLuaFn /* lua */ ''
          dofile(vim.g.base46_cache .. "nvimtree")
          return ${inConfig "nvimtree"}
        '';
      }
      {
        pkg = which-key-nvim;
        keys = [ "<leader>" "<c-r>" "<c-w>" "\"" "'" "`" "c" "v" "g" ];
        cmd = ["WhichKey"];
        opts.__raw = mkLuaFn /* lua */ ''
          dofile(vim.g.base46_cache .. "whichkey")
          return {}
        '';
      }

      # formatting!
      {
        pkg = conform-nvim;
        opts = {
          formatters_by_ft = { lua = [ "stylua" ]; };
        };
      }

      #  git stuff
      {
        pkg = gitsigns-nvim;
        event = "User FilePost";
        opts.__raw = mkLuaFn /* lua */ ''
          dofile(vim.g.base46_cache .. "git")
          return ${inConfig "gitsigns"}
        '';
      }

      # lsp stuff
      {
        pkg = mason-nvim;
        cmd = [ "Mason" "MasonInstall" "MasonInstallAll" "MasonUpdate" ];
        opts.__raw = mkLuaFn /* lua */ ''
          dofile(vim.g.base46_cache .. "mason")
          return ${inConfig "mason"}
        '';
      }
      {
        pkg = nvim-lspconfig;
        event = "User FilePost";
      }

      {
        pkg = telescope-nvim;
        dependencies = [ nvim-treesitter ];
        cmd = "Telescope";
        opts.__raw = mkLuaFn /* lua */ ''
          dofile(vim.g.base46_cache .. "telescope")
          return ${inConfig "telescope"}
        '';
      }
      # nvim-treesitter
      
      {
        pkg = nvim-treesitter;
        event = [ "BufReadPost" "BufNewFile" ];
      #   cmd = [ "TSInstall" "TSBufEnable" "TSBufDisable" "TSModuleInfo" ];
      }
    ];
  };
}
