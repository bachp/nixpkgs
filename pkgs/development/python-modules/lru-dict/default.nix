{ lib, fetchPypi, buildPythonPackage, pytestCheckHook }:

buildPythonPackage rec {
  pname = "lru-dict";
  version = "1.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z1d0dj9hm2yrcfm66514ag2mi798yd7kpms791x8haksxkizf25";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/amitdev/lru-dict";
    description = "An Dict like LRU container.";
    license = licenses.mit;
    maintainers = with maintainers; [ bachp ];
  };
}
