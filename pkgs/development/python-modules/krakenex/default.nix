{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "krakenex";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xfgllffydivxpm713f8rv4dymfj51lvwc48i7fkpasywxl8g96v";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    homepage = "https://github.com/veox/python3-krakenex";
    description = "REST Exchange API for Kraken.com, Python 3";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ bachp ];
  };
}
