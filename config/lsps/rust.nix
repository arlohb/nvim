{ pkgs, ... }:
{
  rust_analyzer = {
    enable = true;
    installCargo = false;
    installRustc = false;
  };
}
