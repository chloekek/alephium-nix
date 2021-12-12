{ fetchurl, jre, makeWrapper, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
    pname = "alephium";
    version = "1.1.11";

    src = fetchurl {
        url = "https://github.com/alephium/alephium/releases/download/v${version}/alephium-${version}.jar";
        sha256 = "0ibrr65xxr4rh1nbyrvxgbw788ypyrqflr3fzzfdr5ik5dwv7p6i";
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
