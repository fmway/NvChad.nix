{ config, lib, ... }:
{
  _file = ./options.nix;
  config = lib.mkIf config.nvchad.enable {
    # -------------------------------------- options ------------------------------------------
    vim.o.laststatus = 3;
    vim.o.showmode = false;

    vim.o.clipboard = "unnamedplus";
    vim.o.cursorline = true;
    vim.o.cursorlineopt = "number";

    # Indenting
    vim.o.expandtab = true;
    vim.o.shiftwidth = 2;
    vim.o.smartindent = true; # deprecated
    vim.o.cindent = true;
    vim.o.breakindent = true;
    vim.o.tabstop = 2;
    vim.o.softtabstop = 2;

    opts.fillchars = { eob = " "; };
    vim.o.ignorecase = true;
    vim.o.smartcase = true;
    vim.o.mouse = "a";

    # Numbers
    vim.o.number = true;
    vim.o.numberwidth = 2;
    vim.o.ruler = false;


    vim.o.signcolumn = "yes";
    vim.o.splitbelow = true;
    vim.o.splitright = true;
    vim.o.timeoutlen = 400;
    vim.o.undofile = true;

    # interval for writing swap file to disk, also used by gitsigns
    vim.o.updatetime = 250;

    # disable some default providers
    globals.loaded_node_provider = 0;
    globals.loaded_python3_provider = 0;
    globals.loaded_perl_provider = 0;
    globals.loaded_ruby_provider = 0;
  };
}
