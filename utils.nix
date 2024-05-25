pkgs:
let
  lib = pkgs.lib;
in
rec {
  # Go from my nicer plugin syntax to a nixvim module
  #
  # For example:
  # {
  #   # Parse this as a nixvim module
  #   nixvim = {
  #     plugins.treesitter.enable = true;
  #   };
  #
  #   # Lua config not directly linked to a plugin
  #   none = ''
  #     vim.opt.encoding = "utf8";
  #   '';
  #
  #   # Install a plugin with no config
  #   plenary-nvim = "";
  #
  #   # Install a plugin with lua config
  #   telescope-nvim = ''
  #     require("telescope").setup {}
  #   '';
  # }
  # 
  parsePlugins = lib.attrsets.foldlAttrs
    (result: name: value:
      if name == "nixvim"
      then (result // value)
      else result // {
        extraPlugins = result.extraPlugins
        ++ (if name != "none"
          then [
            pkgs.vimPlugins."${name}"
          ]
          else [ ]);
        extraConfigLua = result.extraConfigLua + value;
      }
    )
    { extraPlugins = []; extraConfigLua = ""; };

  # Make the nixvim instance with a list of modules in plugin syntax
  makeNixvimFromPlugins = nixvim: lib.lists.foldl
    (result: module: result.nixvimExtend (parsePlugins module))
    (nixvim.makeNixvimWithModule {
      inherit pkgs;
      module = {};
    });

  # Merge a list of attrsets, doesn't do any clever recursive merging
  mergeAttrSets = lib.lists.foldl
    (result: set: result // set)
    {};

  # Get the folders inside a directory
  folders_in_dir = dir:
    lib.attrsets.mapAttrsToList
      (path: type: path)
      (
        lib.attrsets.filterAttrs
          (path: type: type == "directory")
          (builtins.readDir dir)
      );

  # Get the files inside a directory
  files_in_dir = dir:
    lib.attrsets.mapAttrsToList
      (path: type: path)
      (
        lib.attrsets.filterAttrs
          (path: type: type == "regular")
          (builtins.readDir dir)
      );

  # Add the file name to the end of a path and return as a path
  prepend_path = path: name: path + ("/" + name);

  # Like folders_in_dir but returns paths
  folder_paths_in_dir = dir: map (prepend_path dir) (files_in_dir dir);

  # Like files_in_dir but returns paths
  file_paths_in_dir = dir: map (prepend_path dir) (files_in_dir dir);
}
