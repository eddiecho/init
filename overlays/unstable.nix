inputs: _final: prev: {
  unstable = import inputs.nixpkgs {
    inherit (prev) system config;
    overlays = [];
  };
}
