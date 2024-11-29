{ lib, config, ... }:
{
  _file = ./.;
  imports = [
    ./nvconfig.nix
    ./vim.nix
    ./lazy.nix
  ];
  options = with lib; {
    dashboard.enable = mkEnableOption "enable default dasboard";
    nvchad.enable = mkEnableOption "enable nvchad" // { default = true; };
  };
  config = {
    globals.mapleader = lib.mkDefault " ";
    extraConfigLuaPost =
      lib.optionalString (!config.dashboard.enable) /* lua */ ''
        vim.opt.shortmess:append "sI"
      '';
  };
}
