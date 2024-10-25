{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "zenoh-c";
  version = "0.6.0-beta.1";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-c";
    #rev = version;
    rev = "ade1e92b314d8ffbf9ac3e852f6371a1487fb546";
    sha256 = "sha256-DWVuwwSaq2zoU/W8i0+pTh35ZQK8PO3HoDe0XEaHW4k=";
  };

  patches = [
    ./0001-Respect-gnuinstalldirs-for-pkgconfig-directory.patch
    ./0002-Use-full-path-in-pkgconfig.patch
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-Vk1t3/g6KOYorMz1JEqySCZTXL3bZjzVeTxjnOJ43+c=";
  };

  nativeBuildInputs = [ cmake
  ] ++ (with rustPlatform; [
    rust.cargo
    cargoSetupHook
  ]);

  meta = with lib; {
    description = "zenoh client library written in C and targeting micro-controllers.";
    homepage = "https://zenoh.io/";
    license = with licenses; [ asl20 epl10 ];
    maintainers = with maintainers; [ bachp ];
  };
}
