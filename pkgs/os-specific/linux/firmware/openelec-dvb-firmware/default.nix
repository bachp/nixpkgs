{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "openelec-dvb-firmware";
  version = "0.0.51";

  src = fetchFromGitHub {
    owner = "OpenELEC";
    repo = "dvb-firmware";
    rev = version;
    sha256 = "1g8xcqy660ifqw8aq63w5ylwpgxhc9q5k1shhyfqcxjbplxjs0z5";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    DESTDIR="$out" ./install
    find $out \( -name 'README.*' -or -name 'LICEN[SC]E.*' -or -name '*.txt' \) | xargs rm
  '';

  meta = with lib; {
    description = "DVB firmware from OpenELEC";
    homepage = "https://github.com/OpenELEC/dvb-firmware";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    priority = 7;
  };
}
