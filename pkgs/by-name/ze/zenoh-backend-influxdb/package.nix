{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-backend-influxdb";
  version = "1.7.1"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-influxdb";
    tag = version;
    hash = "sha256-Y2r8bFBHX3LtVh2aNnav/ZPRBC0vBjEXHxqhRuaITpc=";
  };

  cargoHash = "sha256-KdsM7E+1jDqgc6zYE9L3QQfnIT2w5xlm7dAV/ocJ+Iw=";

  meta = {
    description = "Backend and Storages for zenoh using InfluxDB";
    homepage = "https://github.com/eclipse-zenoh/zenoh-backend-influxdb";
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
