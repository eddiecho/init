{
  programs.zsh = {
    enable = true;
    shellAliases = {
      nvimswaps = "pushd; cd ~/.local/state/nvim/swap";
      hms = "home-manager switch --flake ~/.config/home-manager --show-trace";
      nixgc = "nix-collect-garbage";

      sudo = "nixsudo";
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };

    oh-my-zsh = {
      enable = true;
      theme = "gallifrey";

      plugins = [
        "git"
      ];
    };
  };
}
