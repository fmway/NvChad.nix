{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvchad = {
      url = "github:fmway/nvchad.nix";
      inputs.nixvim.follows = "nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
    inherit (nixpkgs) lib;
    inherit (self) outputs;
    system = "x86_64-linux";
  in {
    nixosConfigurations.default = lib.nixosSystem {
      modules = [
        inputs.nvchad.nixosModules.default
        ({ lib, ... }: {
          programs.nixvim.imports = [ ./config/nvim ];
          programs.nixvim.enable = true;
          programs.neovim.enable = lib.mkForce false;
        })
      ];
      specialArgs = {
        inherit inputs outputs system;
      };
      inherit system;
    }; 
  };
}
