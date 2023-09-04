{ config, pkgs, ... }:

{
  # Probably won't work on Mac
  targets.genericLinux.enable = true;

  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = "eddie";
    homeDirectory = "/home/eddie";
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
      cloc
      ripgrep
      # needed for nvim stuff
      unzip
      tldr
      tmux
      tree

      # home-manager can install zsh, but can't set it as default shell
      # need to do it manually...
      # which zsh | sudo tee -a /etc/shells
      # chsh -s $(which zsh)
      zsh

      # I guess I'm not supposed to add it here? So confused.
      # We're going to manage it manually, since nvim moves so fast
      # it breaks plugins all the time.
      # Also the nightly overlay makes it build from scratch everytime
      # I update any piece of my setup.
      # neovim

      # lots of nvim stuff need it
      nodejs_20

      clang_16
      clang-tools_16
      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      nvim = {
        recursive = true;
        source = ./apps/neovim/config;
        target = ".config/nvim";
      };
    };

    # You can also manage environment variables but you will have to manually
    # source
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/eddie/etc/profile.d/hm-session-vars.sh
    #
    # if you don't want to manage your shell through Home Manager.
    sessionVariables = {
      # EDITOR = "emacs";
    };
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      # remember to run nix-collect-garbage regularly, since home-manager can't do it
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  imports = [
    ./apps
  ];
}