{ config, lib, ... }:
let
  mkRaw = __raw: { inherit __raw; };
in {
  _file = ./lua_ls.nix;
  config.plugins.lsp.servers.lua_ls = lib.mkIf config.nvchad.enable {
    enable = true;
    settings = {
      diagnostics.globals = [ "vim" ];
      workspace = {
        library = [
          (mkRaw /* lua */ ''vim.fn.expand "$VIMRUNTIME/lua"'')
          (mkRaw /* lua */ ''vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"'')
          (mkRaw /* lua */ ''vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"'')
          (mkRaw /* lua */ ''vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"'')
          "\${3rd}/luv/library"
        ];
        maxPreload = 100000;
        preloadFileSize = 10000;
      };
    };
  };
}
