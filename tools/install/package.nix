{pkgs, ...}:
pkgs.writeShellScriptBin "install" ''
  set -e

  FLAKE=$1
  FLAKE_URI=''${2:-github:eddiecho/init}
  ${pkgs.nixos-install-tools}/bin/nixos-install --flake "''${FLAKE_URI}#''${FLAKE}"
''
