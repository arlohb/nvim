{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { nixvim, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, system, ... }:
        let
          utils = import ./utils.nix pkgs;

          paths = utils.file_paths_in_dir ./config;
          modules = (builtins.filter
            (pkgs.lib.strings.hasSuffix ".nix")
            paths
          );
          mergedModule = (utils.mergeAttrSets
            (map
              (path: (import path) { inherit pkgs; })
              modules
            )
          );

          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nixvimModule = {
            inherit pkgs;
            module = { pkgs, lib, ... }@moduleInputs:
              utils.parsePlugins mergedModule;
          };
          nvim = nixvim'.makeNixvimWithModule nixvimModule;
        in
        {
          checks.default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
          packages.default = nvim;
        };
    };
}
