{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-plugin-webserver";
  version = "1.7.1"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-webserver";
    tag = version;
    hash = "sha256-qxyb8Q+YMGuOEgQPyTYzULGZbHx4KYjmKtFe4Y2Qkw8=";
  };

  cargoHash = "sha256-DoP1sU0UmgxsbebVrAxQttjh62OX5qOWylYmkU9OaSs=";

  meta = {
    description = "Implements an HTTP server mapping URLs to zenoh paths";
    homepage = "https://github.com/eclipse-zenoh/zenoh-plugin-webserver";
    license = with lib.licenses; [
      epl20
      asl20
    ];
    maintainers = with lib.maintainers; [
      markuskowa
      bachp
    ];
    platforms = lib.platforms.linux;
  };
}
