{ lib, stdenv, dpkg, makeWrapper, fetchurl }:

stdenv.mkDerivation rec {
  pname = "adspower";
  version = "8.6.3";

  src = ./AdsPower-Global-8.6.3-x64.deb;

  nativeBuildInputs = [ dpkg makeWrapper ];

  unpackPhase = ''
    dpkg-deb -x "$src" .
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt"
    cp -r "opt/AdsPower Global" "$out/opt/adspower-global"

    mkdir -p "$out/share/applications" "$out/share/pixmaps"
    cp usr/share/applications/* "$out/share/applications/" 2>/dev/null || true
    cp usr/share/pixmaps/* "$out/share/pixmaps/" 2>/dev/null || true

    mkdir -p "$out/bin"

    makeWrapper "$out/opt/adspower-global/adspower_global" "$out/bin/adspower" \
      --set ELECTRON_IS_DEV 0 \
      --add-flags "--no-sandbox" \
      --add-flags "--enable-unsafe-swiftshader"

    runHook postInstall
  '';

  meta = with lib; {
    description = "AdsPower anti-detect browser";
    homepage = "https://adspower.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "adspower";
  };
}
