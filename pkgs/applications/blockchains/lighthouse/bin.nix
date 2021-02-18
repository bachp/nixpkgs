{ lib, stdenv
, fetchurl
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "lighthouse-bin";
  version = "2.1.0";

  src = if stdenv.hostPlatform.system == "aarch64-linux" then fetchurl {
    url = "https://github.com/sigp/lighthouse/releases/download/v${version}/lighthouse-v${version}-aarch64-unknown-linux-gnu-portable.tar.gz";
    hash = "sha256-bd+C0mmgUBafzUcd1WMeFSCoKwr3DLnjd9rfi/tw7DI=";
  } else fetchurl {
    url = "https://github.com/sigp/lighthouse/releases/download/v${version}/lighthouse-v${version}-x86_64-unknown-linux-gnu-portable.tar.gz";
    hash = "sha256-CBLUEp91N9l45onObzS2ed6b7EpoxcBYgVULQWH4qIU=";
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
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
