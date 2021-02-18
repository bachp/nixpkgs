{ lib, stdenv
, fetchurl
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "lighthouse-bin";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/sigp/lighthouse/releases/download/v${version}/lighthouse-v${version}-x86_64-unknown-linux-gnu-portable.tar.gz";
    sha256 = "0wvdzmwlacky6v2v34jy3h30v22p63cvvmn6f3nv36wv94igc5q6";
  };

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=$(pwd)";

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 -D lighthouse $out/bin/
  '';

  meta = with lib; {
    description = "An open-source Ethereum 2.0 client, written in Rust.";
    homepage = "https://github.com/sigp/lighthouse";
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
    platforms = [ "x86_64-linux" ];
  };
}
