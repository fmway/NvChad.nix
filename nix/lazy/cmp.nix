{ pkgs, nixvimLib, config, lib, ... }: let
  inherit (nixvimLib) helpers;
  inherit (helpers) mkLuaFn;
  inConfig = name:
    helpers.toLuaObject (import (./configs + "/${name}.nix") { inherit pkgs helpers inConfig; });
in {
  _file = ./cmp.nix;
  config = lib.mkIf config.nvchad.enable {
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      {
        pkg = nvim-cmp;
        event = "InsertEnter";
        dependencies = [
          {
            # snippet plugin
            pkg = luasnip;
            dependencies = [ friendly-snippets ];
            opts = { history = true; updateevents = "TextChanged,TextChangedI"; };
            config.__raw = mkLuaFn [ "_" "opts" ] /* lua */ ''
              require("luasnip").config.set_config(opts)
              -- vscode format
              require("luasnip.loaders.from_vscode").lazy_load { exclude = vim.g.vscode_snippets_exclude or {} }
              require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

              -- snipmate format
              require("luasnip.loaders.from_snipmate").load()
              require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

              -- lua format
              require("luasnip.loaders.from_lua").load()
              require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

              vim.api.nvim_create_autocmd("InsertLeave", {
                callback = function()
                  if
                    require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                    and not require("luasnip").session.jump_active
                  then
                    require("luasnip").unlink_current()
                  end
                end,
              })
            '';
          }

          # autopairing of (){}[] etc
          {
            pkg = nvim-autopairs;
            opts = {
              fast_wrap = {};
              disable_filetype = [ "TelescopePrompt" "vim" ];
            };
            config.__raw = mkLuaFn [ "_" "opts" ] /* lua */ ''
              require("nvim-autopairs").setup(opts)

              -- setup cmp for autopairs
              local cmp_autopairs = require "nvim-autopairs.completion.cmp"
              require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
            '';
          }

          # cmp sources plugins
          cmp_luasnip
          cmp-nvim-lua
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
        ];
        opts.__raw = mkLuaFn /* lua */ ''
          dofile(vim.g.base46_cache .. "cmp")

          local cmp = require "cmp"
          local options = ${inConfig "cmp"}
          return vim.tbl_deep_extend("force", options, require "nvchad.cmp")
        '';
      }
    ];
  };
}
