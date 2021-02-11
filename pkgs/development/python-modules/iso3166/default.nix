{ lib, fetchPypi, buildPythonPackage, pytestCheckHook }:

buildPythonPackage rec {
  pname = "iso3166";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ig8v9lsf6z7f8pqbb12z2w31nqcgw2sdiwf86f2rfqgyny8vrdi";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/deactivated/python-iso3166";
    description = "Self-contained ISO 3166-1 country definitions";
    license = licenses.mit;
    maintainers = with maintainers; [ zraexy ];
  };
}
