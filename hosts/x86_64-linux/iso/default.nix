# Installer ISO. Build it with `just iso`.
# See tools/install/README.md for the install steps.
{
  modulesPath,
  pkgs,
  root,
  ...
}: {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    git
    tools.install
  ];

  # This is a read-only store copy without .git. Copy it before you edit it.
  environment.etc."init".source = root;

  catppuccin = {
    enable = false;
    autoEnable = false;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
