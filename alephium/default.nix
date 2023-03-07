{ fetchurl, jre, makeWrapper, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
    pname = "alephium";
    version = "1.7.1";

    src = fetchurl {
        url = "https://github.com/alephium/alephium/releases/download/v${version}/alephium-${version}.jar";
        sha256 = "cTscfxV83xKSv/9Y6XF84p297jujo+OlTZoqA5tAbRg=";
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
