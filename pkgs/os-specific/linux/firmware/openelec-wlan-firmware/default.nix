{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "openelec-wlan-firmware";
  version = "0.0.31";

  src = fetchFromGitHub {
    owner = "OpenELEC";
    repo = "wlan-firmware";
    rev = version;
    sha256 = "1s87qi1m21mh76n7hqqf3xas0f2x034ahp187yavfasppydcxdvl";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    DESTDIR="$out" ./install
    find $out \( -name 'README.*' -or -name 'LICEN[SC]E.*' -or -name '*.txt' \) | xargs rm
  '';

  meta = with lib; {
    description = "WLAN firmware from OpenELEC";
    homepage = "https://github.com/OpenELEC/wlan-firmware";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    priority = 7;
  };
}
