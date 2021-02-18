{ lib, fetchPypi, buildPythonPackage, pytestCheckHook
, scikit-build, cmake, c-blosc
 }:

buildPythonPackage rec {
  pname = "blosc";
  version = "1.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16zdrcm4k64rrpd1zsaclnbrbfh33b8fikngqmynkkdya8pr5fpf";
  };

  nativeBuildInputs = [ scikit-build cmake ];
  buildInputs = [ c-blosc ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "http://github.com/blosc/python-blosc";
    description = "Blosc data compressor";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bachp ];
  };
}
