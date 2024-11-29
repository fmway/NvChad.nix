{
  _file = ./.;
  imports = [
    ./lazy
    ./lsp
    ./keymaps.nix
    ./options.nix
    ./treesitter.nix
    ./autocmds.nix
  ];
  extraConfigLua = /* lua */ ''
    -- go to previous/next line with h,l,left arrow and right arrow
    -- when cursor reaches end/beginning of line
    vim.opt.whichwrap:append "<>[]hl"
  '';
}
