{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages
, cmake
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-plugin-dds";
  version = "0.6.0-beta.1";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = pname;
    rev = version;
    sha256 = "sha256-nkeyk32qm52wh3tNoQ6jXHJSP6FZFmkEofvL4M+pQCQ=";
  };

  cargoSha256 = "sha256-oFhVaLPWeprCQJ34GMPaSA6lI8YJunBlGa3pkeNYwXs=";

  # needed for cyclondds build
  nativeBuildInputs = [ llvmPackages.clang cmake ];
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  meta = with lib; {
    description = "A zenoh plug-in that allows to transparently route DDS data.";
    homepage = "https://zenoh.io/";
    license = with licenses; [ asl20 epl10 ];
    maintainers = with maintainers; [ bachp ];
  };
}
