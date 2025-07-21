{config, ...}: {
  home-manager.users.${config.user} = {
    programs.git = {
      enable = true;
      userName = config.fullName;
      userEmail = config.gitEmail;

      extraConfig = {
        core = {
          editor = "nvim";
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
