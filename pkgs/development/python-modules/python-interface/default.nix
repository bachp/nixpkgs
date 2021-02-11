{ lib, buildPythonPackage, fetchPypi, six, pytestCheckHook }:

buildPythonPackage rec {
  pname = "python-interface";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08y1yrvwzg1n27vzc7qz6pi6cv6631vb0iwh7i3jvls5xxziqsmj";
  };

  checkInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Pythonic Interface definitions";
    homepage = "https://github.com/ssanderson/python-interface";
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
  };
}
