inputs: _final: prev: {
  sfmono = prev.stdenvNoCC.mkDerivation rec {
    pname = "sfmono";
    version = "dev";
    src = inputs.sfmono;
    dontConfigure = true;
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp -R $src/*.otf $out/share/fonts/opentype
    '';
  };
}
