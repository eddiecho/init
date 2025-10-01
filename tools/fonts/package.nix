{
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "sfmono-nerdfonts";
  version = "0.1";
  src = ../../static/fonts/SFMono;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    if [ -d ]; then
      cp -r $src/*.{ttf,otf} $out/share/fonts/truetype/
    else
      echo "No fonts found in $src/fonts"
      exit 0
    fi
  '';

  meta = with lib; {
    description = "SFMono Nerd Fonts";
    platforms = platforms.all;
  };
}
