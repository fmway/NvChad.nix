{ config, pkgs, nixvimLib, lib, ... }: let
  inherit (nixvimLib) helpers;
  inherit (helpers) mkLuaFn mkLuaFnWithName;
  nvchad-ui-patch = pkgs.vimPlugins.nvchad-ui.overrideAttrs (old: {
    nvimSkipModules = (old.nvimSkipModules or []) ++ [
      "nvchad.au"
    ];
    src = pkgs.stdenv.mkDerivation {
      inherit (old) name src;
      installPhase = ''
        mkdir $out
        cp -r * $out
        cp ${nvconfig} $out/lua/chadrc.lua
      '';
    };
  });
  nvconfig = pkgs.writeText "nvconfig.lua" /* lua */ ''
    local options = ${helpers.toLuaObject config.nvchad.config}
    return options
  '';
  base46-cache = pkgs.stdenv.mkDerivation rec {
    src = pkgs.vimPlugins.base46;
    inherit (src) version;
    name = "base46-cache";
    buildInputs = with pkgs; [ neovim ];
    NVCHAD_UI = nvchad-ui-patch;
    installPhase = ''
      mkdir -p $out/tmp
      cp * $out/tmp/ -r
      substituteInPlace $out/tmp/lua/base46/init.lua \
        --replace-warn "cache_path = vim.g.base46_cache" 'cache_path = "'$out'/"' \
        --replace-warn "if not vim.uv.fs_stat(vim.g.base46_cache) then" "if false then" \
        --replace-warn "loadstring" "load"
      echo "require(\"base46\").compile()" > $out/build.lua
      nvim +":lua package.path = package.path .. \";$out/tmp/lua/?.lua;$out/tmp/lua/?/init.lua;$NVCHAD_UI/lua/?.lua;$NVCHAD_UI/lua/?/init.lua\"" -l $out/build.lua
      rm $out/build.lua $out/tmp -rf
    '';
  };
in {
  _file = ./nvchad.nix;
  options = {
    build.nvconfig = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = nvconfig;
    };
    build.base46 = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = base46-cache;
    };
    build.nvchad-ui = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = nvchad-ui-patch;
    };
  };
  config = lib.mkIf config.nvchad.enable {
    extraPlugins = [
      nvchad-ui-patch
    ];
    # extraFiles."nvchad/lsp/init.lua".source = "${pkgs.vimPlugins.nvchad-ui}/lua/nvchad/lsp/init.lua";
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      {
        name = "nvchad-ui";
        lazy = false;
        pkg = nvchad-ui-patch;
        config.__raw = mkLuaFn /* lua */ ''require "nvchad"'';
      }
      base46
      nvzone-volt
      {
        name = "minty";
        pkg = nvzone-minty;
        cmd = [ "Shades" "Huefy" ];
      }
      nvzone-menu
    ];
    extraConfigLuaPre = /* lua */ ''
      --
      vim.g.base46_cache = "${base46-cache}/"

      -- (method 1, For heavy lazyloaders)
      dofile(vim.g.base46_cache .. "defaults")
      dofile(vim.g.base46_cache .. "statusline")
      
      -- (method 2, for non lazyloaders) to load all highlights at once
      -- for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
      --   dofile(vim.g.base46_cache .. v)
      -- end
    '';
    extraConfigLuaPost = /* lua */ ''
      -- add binaries installed by mason.nvim to path
      local is_windows = vim.fn.has "win32" ~= 0
      local sep = is_windows and "\\" or "/"
      local delim = is_windows and ";" or ":"
      vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
    '';
  };
}
