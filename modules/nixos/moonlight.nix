{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nixos.moonlight;
in {
  options.nixos.moonlight = {
    enable = lib.mkEnableOption "Enable moonlight";
  };

  # ctrl + alt + shift + q to quit
  # default sunshine port is 47990
  config = lib.mkIf (cfg.enable && config.nixos.display.enable) {
    environment.systemPackages = with pkgs; [
      sunshine
      moonlight-qt
    ];

    security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs.sunshine}/bin/sunshine";
    };
  };
}
