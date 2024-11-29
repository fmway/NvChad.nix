# { pkgs, lib, ... }:
{
  plugins.lsp.servers = {
    rust_analyzer.enable = true;
    rust_analyzer.installCargo = true;
    rust_analyzer.installRustc = true;
    zls.enable = true;
    volar.enable = true;
    clangd.enable = true;
    # vls.enable = true;
    # intelephense.enable = true;
    phpactor.enable = true;
    jsonls.enable = true;
    # mint.enable = true;
    # csharp_ls.enable = true;
    # ts_ls.enable = true;
    # ts_ls.rootDir = "require(\"lspconfig\").util.root_pattern(\"package.json\", \"tsconfig.json\")";
    denols.enable = true;
    # denols.rootDir = "require(\"lspconfig\").util.root_pattern(\"deno.json\", \"deno.jsonc\")";
  };
}
