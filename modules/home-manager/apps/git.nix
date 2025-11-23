{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.apps.git;
in {
  options.modules.apps.git = {
    enable = lib.mkEnableOption "Enable git";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      difftastic
    ];

    programs.git = {
      enable = true;

      lfs.enable = true;
      settings = {
        user = {
          email = config.settings.email;
          name = config.settings.fullName;
        };

        core = {
          editor = lib.mkDefault "vi";
          pager = "less -X -F";
        };

        commit = {
          verbose = true;
          cleanup = "scissors";
        };

        fetch = {
          prune = true;
          pruneTags = true;
        };

        rebase = {
          autoSquash = true;
          autoStash = true;
          updateRefs = true;
        };

        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          renames = true;
          external = "difft";
        };

        push = {
          default = "current";
          autoSetupRemote = true;
        };

        branch.sort = "committerdate";
        column.ui = "auto";

        merge.conflictstyle = "diff3";
        pull.rebase = true;

        # Reuse Recorded Resolutions
        rerere.enabled = true;
      };
    };
  };
}
