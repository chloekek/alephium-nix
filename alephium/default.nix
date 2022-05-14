{ fetchurl, jre, makeWrapper, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
    pname = "alephium";
    version = "1.3.2";

    src = fetchurl {
        url = "https://github.com/alephium/alephium/releases/download/v${version}/alephium-${version}.jar";
        sha256 = "0wjysd2pirafkgs5zjxviksp0qiwww5sgwbxcadpl314ld1q3y5q";
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
