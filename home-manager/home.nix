{ config, pkgs, ... }:

let
  basePackages = import ./base_packages.nix pkgs;
in {
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
    packages = with pkgs; basePackages ++ [
      cmake
      gettext
      clang_16
      clang-tools_16

      zig
      zls
      # raylib and its dependencies
      #raylib
      #mesa
      #alsa-lib
      #xorg.xorgproto
      #xorg.libX11.dev
      #xorg.libXft
      #xorg.libXinerama
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      nvim = {
        recursive = true;
        # relative path from current directory
        source = ./apps/neovim/config;
        # relative path from home directory
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
      gcc = "clang";
      WIN_HOME_DIR = "/mnt/c/Users/photo";
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
