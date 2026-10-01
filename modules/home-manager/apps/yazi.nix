{
  config,
  lib,
  ...
}: let
  cfg = config.modules.apps.yazi;
in {
  options.modules.apps.yazi = {
    enable = lib.mkEnableOption "Enable yazi";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      settings.plugin = let
        # netpbm formats: PPM, PGM, PBM, PNM. ImageMagick decodes them.
        netpbm = {
          mime = "image/x-portable-*";
          run = "magick";
        };
      in {
        prepend_preloaders = [netpbm];
        prepend_previewers = [netpbm];
      };
    };
  };
}
