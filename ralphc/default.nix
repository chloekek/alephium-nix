{ fetchurl, jre, makeWrapper, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
    pname = "ralphc";
    version = "1.7.1";

    src = fetchurl {
        url = "https://github.com/alephium/alephium/releases/download/v${version}/alephium-ralphc-${version}.jar";
        sha256 = "HryzP1AUrs4a2Jnui/s1pNa6scVdiI2/A73E7RXxgNM=";
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
