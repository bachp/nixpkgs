{ lib, stdenv
, fetchurl
, autoPatchelfHook
, zlib
}:

stdenv.mkDerivation rec {
  pname = "lighthouse";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/sigp/lighthouse/releases/download/v${version}/lighthouse-v${version}-x86_64-unknown-linux-gnu-portable.tar.gz";
    sha256 = "07vdhkj43fw6lbbwf5qzq0gamsg8zcgck78j74fj7irvxvkfidl7";
  };

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib zlib ];
  #buildPhase = "";

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
