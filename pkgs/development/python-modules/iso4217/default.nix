{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "iso4217";
  version = "1.6.20180829";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p47iq2zlkr40prh02b303mzzk1fg2bwddrjy5r8bjxkxssh9x1k";
  };

  # Module does not include any unittests
  pythonImportsCheck = [ "iso4217" ];

  meta = with lib; {
    homepage = "https://github.com/dahlia/iso4217";
    description = "ISO 4217 currency data package for Python";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ bachp ];
  };
}
