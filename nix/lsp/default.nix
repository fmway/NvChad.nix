{ pkgs, config, lib, nixvimLib, ... }: let
  inherit (nixvimLib) helpers;
  inherit (helpers) mkLuaFn toLuaObject;
in {
  _file = ./.;
  imports = [
    ./lua_ls.nix
  ];
  config = lib.mkIf config.nvchad.enable {
    plugins.lsp = {
      enable = true;
      servers.nixd.enable = true;
      inlayHints = true;
      preConfig = /* lua */ ''
        dofile(vim.g.base46_cache .. "lsp")
        require("nvchad.lsp").diagnostic_config()
      '';
      keymaps.lspBuf = {
        "gD" = "declaration";
        "gd" = "definition";
        "gi" = "implementation";
        "gr" = "references";
        "<leader>sh" = "signature_help";
        "<leader>wa" = "add_workspace_folder";
        "<leader>wr" = "remove_workspace_folder";
        "<leader>D" = "type_definition";
      };
      keymaps.extra = [
        {
          mode = [ "n" ];
          key = "<leader>ra";
          options.desc = "NVRenamer";
          action.__raw = /* lua */ ''require "nvchad.lsp.renamer"'';
        }
        {
          mode = [ "n" "v" ];
          key = "<leader>ca";
          options.desc = "Code action";
          action.__raw = /* lua */ ''vim.lsp.buf.code_action'';
        }
        {
          mode = [ "n" ];
          key = "<leader>wl";
          options.desc = "List workspace folders";
          action.__raw = mkLuaFn /* lua */ ''print(vim.inspect(vim.lsp.buf.list_workspace_folders()))'';
        }
      ];
      setupWrappers = let
        capabilities = toLuaObject {
          textDocument.completion.completionItem = {
            documentationFormat = [ "markdown" "plaintext" ];
            snippetSupport = true;
            preselectSupport = true;
            insertReplaceSupport = true;
            labelDetailsSupport = true;
            deprecatedSupport = true;
            commitCharactersSupport = true;
            tagSupport = { valueSet = [ 1 ]; };
            resolveSupport = {
              properties = [
                "documentation"
                "detail"
                "additionalTextEdits"
              ];
            };
          };
        };
      in [
        (str: /* lua */ ''
          vim.tbl_deep_extend("force",
            ${str} or {},
          {
            on_init = function(client, _)
              if client.supports_method "textDocument/semanticTokens" then
                client.server_capabilities.semanticTokensProvider = nil
              end
            end,
            capabilities = ${capabilities}
          })
        '')
      ];
    };
  };
}
