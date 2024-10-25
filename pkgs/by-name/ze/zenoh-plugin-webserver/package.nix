{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-plugin-webserver";
  version = "0.6.0-beta.1";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = pname;
    rev = version;
    sha256 = "sha256-ls2MJVtfdjIjhZU4vBSOT3XdVWgveirY8/QG1Q6X8CY=";
  };

  cargoSha256 = "sha256-EyWDe1mBWxc/nCq6y51+tCh/fXbWZHH5Omx/GtLB8lc=";

  meta = with lib; {
    description = "A zenoh plug-in implementing an HTTP server mapping URLs to zenoh paths.";
    homepage = "https://zenoh.io/";
    license = with licenses; [ asl20 epl10 ];
    maintainers = with maintainers; [ bachp ];
  };
}
