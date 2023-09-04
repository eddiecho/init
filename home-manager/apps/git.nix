{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Eddie Cho";
    userEmail = "eunseocho@gmail.com";
    extraConfig = {
      core = {
        editor = "vi";
        pager = "less -X -F";
      };
    };
  };
}
