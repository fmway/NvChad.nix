{ pkgs, inputs, lib, config, ... }: let
in {
  imports = [
    ./plugins.nix
    ./keymaps.nix
    ./lsp.nix
    ./treesitter.nix
    ./chadrc.nix
  ];
  
  globals.mapleader = " ";
  # vim.o.cursorlineopt = "both";
  
  # add filetype
  filetype.filename = {
    "build.zig.zon" = "zig";
  };
  filetype.pattern = {
    ".*%.blade%.php" = "blade";
  };
}
