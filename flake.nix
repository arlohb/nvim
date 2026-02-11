{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";

    lecture-notes-nvim.url = "github:arlohb/lecture-notes.nvim";
    # lecture-notes-nvim.url = "git+file:///home/arlo/code/lecture-notes.nvim";

    drop-nvim.url = "github:folke/drop.nvim";
    drop-nvim.flake = false;

    # lean-nvim has removed lean3 support,
    # But left it available with a git tag
    lean3-nvim.url = "github:Julian/lean.nvim?ref=lean3";
    lean3-nvim.flake = false;

    latex-nvim.url = "github:robbielyman/latex.nvim";
    latex-nvim.flake = false;
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
          custom = {
            lecture-notes-nvim = inputs.lecture-notes-nvim.packages."${system}".default;

            drop-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "drop.nvim";
              src = inputs.drop-nvim;
            };

            lean3-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "lean.nvim";
              src = inputs.lean3-nvim;
            };

            latex-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "latex.nvim";
              src = inputs.latex-nvim;
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
            (path: (import path) { inherit pkgs lib custom utils; vscode = false; })
            modulePaths;

          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nvim = utils.makeNixvimFromPlugins nixvim' modules;

          vscode-nvim = utils.makeNixvimFromPlugins nixvim' (map
            (path: (import path) { inherit pkgs lib custom utils; vscode = true; })
            [
              ./config/base.nix
              ./config/editing.nix
              ./config/keys.nix
            ]);
        in
        {
          checks.default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "nixvim-check";
          };
          packages.default = nvim;
          packages.vscode-nvim = vscode-nvim;

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              lua-language-server
            ];
          };
        };
    };
}
