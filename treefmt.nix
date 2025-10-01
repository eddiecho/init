{pkgs, ...}: {
  projectRootFile = "flake.nix";
  programs.stylua.enable = true;
  programs.alejandra.enable = true;
  programs.jsonfmt.enable = true;
  programs.shfmt.enable = true;
}
