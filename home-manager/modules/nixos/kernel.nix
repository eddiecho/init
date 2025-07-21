{ config, pkgs, lib, ... }:

let
  cfg = config.nixos.kernel;
in

{
  options.nixos.kernel.enable = lib.mkEnableOption "Enable kernel tweaks";

  config = lib.mkIf cfg.enable {

    # I got the need for speed, baby
    boot.kernelParams = [ "mitigations=off" ];
  };
}
