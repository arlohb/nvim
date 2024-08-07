{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
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
        { pkgs, lib, system, ... }:
        let
          utils = import ./utils.nix pkgs;

          modulePaths = (builtins.filter
            (pkgs.lib.strings.hasSuffix ".nix")
            (
              (utils.file_paths_in_dir ./config)
              ++ (utils.file_paths_in_dir ./config/langs)
            )
          );
          modules = map
            (path: (import path) { inherit pkgs lib utils; })
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

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              lua-language-server
            ];
          };
        };
    };
}
