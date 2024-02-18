{ specialArgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Eddie Cho";
    userEmail = specialArgs.email;
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
