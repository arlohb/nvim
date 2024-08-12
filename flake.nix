{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";

    lecture-notes-nvim.url = "github:arlohb/lecture-notes.nvim";
    # lecture-notes-nvim.url = "git+file:///home/arlo/code/lecture-notes.nvim";
    lecture-notes-nvim.flake = false;
  };

  outputs =
    { nixvim, flake-parts, lecture-notes-nvim, ... }@inputs:
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
          custom = {
            lecture-notes-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "lecture-notes";
              src = lecture-notes-nvim;
            };
          };

          utils = import ./utils.nix { inherit pkgs lib custom; };

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
