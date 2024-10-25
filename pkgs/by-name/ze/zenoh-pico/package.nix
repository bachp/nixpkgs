{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "zenoh-pico";
  version = "0.6.0-beta.1";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-pico";
    rev = version;
    sha256 = "sha256-RG8nlWLeOLW3L1R/54CMnMxAh4Pufi6qWSsnhNRsvSw=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Eclipse zenoh for pico devices";
    homepage = "https://zenoh.io/";
    license = with licenses; [ asl20 epl10 ];
    maintainers = with maintainers; [ bachp ];
  };
}
