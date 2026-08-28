{pkgs, ...}:
pkgs.writeShellScriptBin "install" ''
  set -e

  FLAKE=$1
  ${pkgs.nixos-install-tools}/bin/nixos-install --flake github:eddiecho/init#''${FLAKE}
''
