{
  config,
  lib,
  ...
}: let
  cfg = config.modules.apps.sioyek;
in {
  options.modules.apps.sioyek = {
    enable = lib.mkEnableOption "Enable sioyek";
  };

  config = lib.mkIf cfg.enable {
    programs.sioyek.enable = true;
  };
}
