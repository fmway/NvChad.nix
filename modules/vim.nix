{ config, lib, nixvimLib, pkgs, ... }: let
  inherit (nixvimLib) helpers;
  inherit (helpers) toLuaObject;
  cfg = config.vim.o;
in {
  _file = ./vim.nix;
  options = with lib; {
    vim.o = mkOption {
      type = with types; attrsOf anything;
      default = {};
    };
  };
  config = {
    extraConfigLuaPre = let
      varName = "nixvim_o_options";
      content = 
        lib.optionalString (cfg != { }) /* lua */ ''
          -- Set up vim.o {{{
          do
            local ${varName} = ${toLuaObject cfg}

            for k,v in pairs(${varName}) do
              vim.o[k] = v
            end
          end
          -- }}}
        '';
      in
      lib.mkIf (content != "") content;
  };
}
