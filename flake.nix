{
  description = "A Nix-flake-based Python development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };
  outputs = inputs: let
    disabledModules =  ["${inputs.nixvim}/plugins/pluginmanagers/lazy.nix"];
    mkNvchad = { system, modules ? [] }:
      inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
        module.imports = modules ++ [
        { inherit disabledModules; }
          ./nix
          ./modules
        ];
        extraSpecialArgs = genSpecialArgs system // { inherit inputs; };
      };
    getLib = system:
      inputs.nixvim.lib.${system};
    genSpecialArgs = system: let
      nixvimLib = getLib system;
    in {
      nixvimLib = nixvimLib // {
        helpers = nixvimLib.helpers // (let
          generator = { name ? "", args ? [], lua ? "", ... }:
          ''
            function${if name == "" then "" else " ${name}"}(${builtins.concatStringsSep ", " args})
              ${lua}
            end
          '';
        in {
          mkLuaFnWithName = name: x: if builtins.isList x then
            lua: generator { inherit name lua; args = x; }
          else generator { inherit name; args = []; lua = x; };

          mkLuaFn = x: if builtins.isList x then
            lua: generator { inherit lua; args = x; }
          else generator { args = []; lua = x; };
        });
      };
    };
  in 
  inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
    flake = { inherit inputs; lib = { inherit mkNvchad; }; };
    perSystem = { config, self', inputs', pkgs, system, ... }: {
      packages = inputs.nixvim.packages.${system} // rec {
        nvchad = mkNvchad { inherit system; };
        simple = mkNvchad {
          inherit system;
          modules = [
            ./templates/simple/config/nvim
          ];
        };
        default = nvchad;
      };
    };
  } // builtins.listToAttrs (map (name: let
    nvchad = { pkgs, ... }: {
      imports = [ inputs.nixvim.${name}.nixvim ];
      programs.nixvim.imports = [
        {
          _file = ./flake.nix;
          _module.args = genSpecialArgs pkgs.system;
          inherit disabledModules;
        }
        ./nix
        ./modules
      ];
    };
  in {
    inherit name;
    value = {
      inherit nvchad;
      default = nvchad;
    };
  }) ["homeManagerModules" "nixDarwinModules" "nixosModules"]) // {
    inherit (inputs.nixvim) lib legacyPackages;
    templates.default = {
      description = "simple nixos configuration";
      path = ./templates/simple;
    };
  };
}
