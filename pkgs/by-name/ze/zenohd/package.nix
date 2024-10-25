{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "zenohd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh";
    rev = version;
    sha256 = "sha256-1FxX9On8clJrNWnjWblubxcZNAn3id5hkHqp33SQeDc=";
  };

  cargoSha256 = "sha256-PpkDs17QkFFlWPr3edHHdIQaeqiRdn2WcWil0vg1iLg=";

  doCheck = false;

  meta = with lib; {
    description = "Zenoh /zeno/ is a pub/sub/query protocol unifying data in motion, data at rest and computations";
    homepage = "https://zenoh.io/";
    license = with licenses; [ asl20 epl10 ];
    maintainers = with maintainers; [ bachp ];
  };
}
