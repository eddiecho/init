# this line implies that the rest of the module is a function!!!!!!!!!!!!
# so since this is defined in a separate file
# when you import it, you need to pass in the pkgs you get from the top level home file
{ pkgs, ... }:

with pkgs;
[
  cloc
  ripgrep
  tldr
  tmux
  tree
  gnumake
  fd
  awscli2
  jq
  direnv
  traceroute
  delta

  # home-manager can install zsh, but can't set it as default shell
  # need to do it manually...
  # which zsh | sudo tee -a /etc/shells
  # chsh -s $(which zsh)
  zsh

  # We're going to manage it manually, since nvim moves so fast
  # it breaks plugins all the time.
  # Also the nightly overlay makes it build from scratch everytime
  # I update any piece of my setup.
  # At work on a mac, just use homebrew and install the --HEAD version
  # neovim

  # lots of nvim stuff need it
  nodejs_20
  unzip

  # # You can also create simple shell scripts directly inside your
  # # configuration. For example, this adds a command 'my-hello' to your
  # # environment:
  # (pkgs.writeShellScriptBin "my-hello" ''
  #   echo "Hello, ${config.home.username}!"
  # '')
  # sudo has a more limited PATH by default
  # this is technically unsafe but.....
  (writeShellScriptBin "nixsudo" ''
    cmd=$(which $1)
    shift
    sudo "$cmd" $@
  '')
]
