{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      nvimswaps = "pushd; cd ~/.local/state/nvim/swap";
      hms = "home-manager switch --flake ~/.config/home-manager --show-trace";
    };
    oh-my-zsh = {
      enable = true;
      theme = "gallifrey";

      plugins = [
        "git"
        "marlonrichert/zsh-autocomplete"
      ];
    };
  };
}
