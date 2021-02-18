{ lib, fetchFromGitHub, fetchPypi, buildPythonPackage, pytestCheckHook
, numpy, dateutil, toolz, pandas
, parameterized
}:

buildPythonPackage rec {
  pname = "trading-calendars";
  version = "2.1.1";

  src = fetchPypi {
    inherit version;
    pname = "trading_calendars";
    sha256 = "1i2zf0v9ycka3yhm8xvyrqqmy57zn13xq7qf9khqcacl0aw5g4v3";
  };

  # PyPi package doesn't include tests
  /*src = fetchFromGitHub {
    owner = "quantopian";
    repo = "trading_calendars";
    rev = version;
    sha256 = "0bmp8kca8cz97vpl9ns90937dnm7vw32zkv11m5v9k1brsk67sbs";
  };*/

  propagatedBuildInputs = [ numpy dateutil toolz pandas ];

  # No tests in PyPi package
  pythonImportsCheck = [ "trading_calendars" ];
  #checkInputs = [ pytestCheckHook parameterized ];

  meta = with lib; {
    homepage = "https://github.com/quantopian/trading_calendars";
    description = "trading_calendars is a Python library with securities exchange calendars used by Quantopian's Zipline.";
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
  };
}
