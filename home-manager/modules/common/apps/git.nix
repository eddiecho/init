{ ... }:

{
  programs.git = {
    enable = true;
    userName = config.fullName;
    userEmail = config.gitEmail;
    extraConfig = {
      core = {
        editor = "nvim";
        pager = "delta";
      };
      diff.algorithm = "histogram";
      pull.rebase = true;
      push.default = "current";
      merge.conflictstyle = "diff3";
      commit.verbose = true;
      rerere.enabled = true;
      branch.sort = "committerdate";
      commit.cleanup = "scissors";
    };
  };
}
