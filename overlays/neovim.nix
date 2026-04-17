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

  tree-sitter = let
    src = prev.fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter";
      rev = "v0.26.8";
      sha256 = "fcFEfoALrbpBD6rWogxJ7FNVlvDQgswoX9ylRgko+8Q=";
    };
  in
    prev.tree-sitter.overrideAttrs (oldAttrs: {
      version = "0.26.8";
      inherit src;
      patches = [];
      cargoHash = "";
      cargoDeps = prev.rustPlatform.fetchCargoVendor {
        inherit src;
        hash = "sha256-9FeWnWWPUWmMF15Psmul8GxGv2JceHWc2WZPmOr81gw=";
      };
      nativeBuildInputs =
        (oldAttrs.nativeBuildInputs or [])
        ++ [
          prev.llvmPackages.clang
          prev.llvmPackages.libclang.lib
        ];
      LIBCLANG_PATH = "${prev.llvmPackages.libclang.lib}/lib";
      BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${prev.llvmPackages.libclang.lib}/lib/clang/${prev.llvmPackages.libclang.version}/include";
    });

  tree-sitter-grammars = prev.tree-sitter-grammars.tree-sitter-lua.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "tree-sitter-grammars";
      repo = "tree-sitter-lua";
      rev = "master"; # Or a specific recent hash
      sha256 = "..."; # Nix will complain and give you the correct hash
    };
  });
}
