{
  description = "A cross-platform Neovim config (plain Lua + lazy.nvim), wrapped for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, lib, ... }:
        let
          # Only the files Neovim reads, so editing the README or flake
          # doesn't change the config's store path
          config = lib.fileset.toSource {
            root = ./.;
            fileset = lib.fileset.unions [
              ./init.lua
              ./lua
              ./after
              ./lazy-lock.json
            ];
          };

          # Tools the config expects on PATH. Appended to PATH, so versions
          # from a project's direnv shell take priority.
          runtimeDeps = with pkgs; [
            # lazy.nvim
            git
            # telescope, mkdnflow
            ripgrep
            fd
            # nvim-treesitter (main branch) compiles parsers
            tree-sitter
            gcc
            curl
            gnutar
            gzip
            # lecture-notes.nvim YouTube downloads
            yt-dlp
            ffmpeg
            # snacks.nvim LaTeX rendering
            tectonic
            ghostscript
          ];

          nvim = pkgs.symlinkJoin {
            name = "nvim";
            paths = [ pkgs.neovim-unwrapped ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/nvim \
                --add-flags "-u ${config}/init.lua" \
                --set ARLO_NVIM_NIX 1 \
                --suffix PATH : ${lib.makeBinPath runtimeDeps}
            '';
            meta.mainProgram = "nvim";
          };
        in
        {
          packages.default = nvim;
          # Same config; plugins marked `vscode = true` are the only ones
          # loaded when vscode-neovim sets vim.g.vscode
          packages.vscode-nvim = nvim;

          # Plugins are fetched by lazy.nvim at runtime (the sandbox has no
          # network), so this only checks the Lua parses and the lockfile is
          # valid JSON
          checks.default = pkgs.runCommand "nvim-config-check"
            { nativeBuildInputs = [ pkgs.luajit pkgs.jq ]; }
            ''
              find ${config} -name '*.lua' -print0 \
                | xargs -0 -n1 sh -c 'luajit -bl "$0" > /dev/null'
              jq empty ${config}/lazy-lock.json
              touch $out
            '';

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              lua-language-server
              stylua
            ];
          };
        };
    };
}
