{ fetchurl, jre, makeWrapper, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
    pname = "ralphc";
    version = "1.6.2";

    src = fetchurl {
        url = "https://github.com/alephium/alephium/releases/download/v${version}/alephium-ralphc-${version}.jar";
        sha256 = "9c147da5c59dd230a9bc4625d9de0124599ceee25d76645908d296d4af459a77";
    };

    buildInputs = [
        makeWrapper
    ];

    phases = [
        "installPhase"
    ];

    installPhase = ''
        mkdir --parents "$out"/bin
        makeWrapper            \
            ${jre}/bin/java    \
            "$out"/bin/ralphc  \
            --add-flags -jar   \
            --add-flags "$src"
    '';
}
