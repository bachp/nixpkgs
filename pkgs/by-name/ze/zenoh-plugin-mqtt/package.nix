{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-plugin-mqtt";
  version = "1.7.1"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-mqtt";
    tag = version;
    hash = "sha256-HbdaOLrGiIoiRZJrNC2spd0yK4Lf8noibpPMo6DvwMA=";
  };

  cargoHash = "sha256-N8JwmFdpnLxAhJmlOC/UNUYoijmXjhuzin9XlfqWLlY=";

  # Some test time out
  doCheck = false;

  meta = {
    description = "Zenoh plug-in that allows to integrate and/or route MQTT pub/sub with Eclipse Zenoh";
    homepage = "https://github.com/eclipse-zenoh/zenoh-plugin-mqtt";
    license = with lib.licenses; [
      epl20
      asl20
    ];
    maintainers = with lib.maintainers; [
      markuskowa
      bachp
    ];
    platforms = lib.platforms.linux;
    mainProgram = "zenoh-bridge-mqtt";
  };
}
