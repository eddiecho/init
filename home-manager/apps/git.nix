{ specialArgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Eddie Cho";
    userEmail = specialArgs.email;
    extraConfig = {
      core = {
        editor = "nvim";
        pager = "less -X -F";
      };
    };
  };
}
