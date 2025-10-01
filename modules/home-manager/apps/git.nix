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
    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = config.settings.fullName;
      userEmail = config.settings.email;

      extraConfig = {
        core = {
          editor = lib.mkDefault "vi";
          pager = "less -X";
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
