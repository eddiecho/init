{lib, ...}: {
  options.settings = import ../../lib/global-options.nix {inherit lib;};
}
