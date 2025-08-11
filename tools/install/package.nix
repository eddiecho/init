{pkgs, ...}:
pkgs.writeShellScriptBin "installer" ''
  set -e

  FLAKE=$1
  ${pkgs.nixos-install-tools}/bin/nixos-install --flake github:eddiecho/init#''${FLAKE}
''
