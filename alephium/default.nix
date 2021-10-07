{ fetchurl, jre, makeWrapper, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
    pname = "alephium";
    version = "0.11.1";

    src = fetchurl {
        url = "https://github.com/alephium/alephium/releases/download/v${version}/alephium-${version}.jar";
        sha256 = "1dpr4x83kw4ghy28zhnlnimz0kc0qfb5lngx8ivnbffzj4yla5zx";
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
