{ lib, fetchPypi, buildPythonPackage, pytestCheckHook
, numpy, cython, setuptools-scm, nose
}:

buildPythonPackage rec {
  pname = "bcolz";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l8b6202hnsjj6735jvlnpimna1q6qzkl8mfy83vnnybn2dx05y0";
  };

  # AVX2 has protability issues, as a workaround we disable it
  # https://github.com/Blosc/bcolz/issues/398
  preBuild = ''export DISABLE_BCOLZ_AVX2=true'';

  nativeBuildInputs = [ setuptools-scm cython ];
  propagatedBuildInputs = [ numpy ];
  checkInputs = [ nose ];

  # TODO: fix tests
  doCheck = false;
  checkPhase = ''
    nosetests --with-coverage --cover-package bcolz bcolz/tests/test_*.py
  '';

  meta = with lib; {
    homepage = "http://bcolz.blosc.org/";
    description = "columnar and compressed data containers.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bachp ];
  };
}
