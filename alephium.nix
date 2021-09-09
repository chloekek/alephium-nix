{ fetchurl, jre, makeWrapper, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
    pname = "alephium";
    version = "0.9.0";

    src = fetchurl {
        url = "https://github.com/alephium/alephium/releases/download/v${version}/alephium-${version}.jar";
        sha256 = "1gfgvzbfpy98dcd5aasvg3zx78h9aa7m9pc97hskqs7iwg5q82g3";
    };

    buildInputs = [
        makeWrapper
    ];

    phases = [
        "installPhase"
    ];

    installPhase = ''
        mkdir --parents "$out"/bin
        makeWrapper             \
            ${jre}/bin/java     \
            "$out"/bin/alephium \
            --add-flags -jar    \
            --add-flags "$src"
    '';
}
