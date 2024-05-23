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

          modulePaths = (builtins.filter
            (pkgs.lib.strings.hasSuffix ".nix")
            (utils.file_paths_in_dir ./config)
          );
          modules = map
            (path: (import path) { inherit pkgs; })
            modulePaths;

          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nvim = utils.makeNixvimFromPlugins nixvim' modules;
        in
        {
          checks.default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "nixvim-check";
          };
          packages.default = nvim;
        };
    };
}
