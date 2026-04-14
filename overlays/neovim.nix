inputs: _final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "0.12.1";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v0.12.1";
      sha256 = "cbFM5TKGmhEDsdhMvGzMyn0Js0MJwdMwXDkzQcdw/TM=";
    };
  });
}
