{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Eddie Cho";
    userEmail = "eunseocho@gmail.com";
    extraConfig = {
      core = {
        editor = "nvim";
        pager = "less -X -F";
      };
    };
  };
}
