{ lib
, buildPythonPackage
, fetchPypi
, pandas
, krakenex
}:

buildPythonPackage rec {
  pname = "pykrakenapi";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03jznqvl0clypl2p76x3csf5zib5x8rblrqbvjkiwyajx7g8x4m7";
  };

  propagatedBuildInputs = [ pandas krakenex ];

  meta = with lib; {
    homepage = "https://github.com/dominiktraxl/pykrakenapi/";
    description = "A python implementation of the Kraken API.";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ bachp ];
  };
}
