{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf (pkgs.stdenv.isLinux && config.wsl.enable) {
  };
}
