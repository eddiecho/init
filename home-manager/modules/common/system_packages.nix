# this line implies that the rest of the module is a function!!!!!!!!!!!!
# so since this is defined in a separate file
# when you import it, you need to pass in the pkgs you get from the top level home file
{pkgs, ...}:
# these are environment packages, available to all users
with pkgs; [
  git
  ripgrep
  neovim
  wget
  curl
  cloc
  fd
  jq
  tree
  unzip
  clang
]
