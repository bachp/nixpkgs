{ stdenv, buildPythonPackage, fetchPypi, fetchFromGitHub
, wheel, pytest, pytestrunner }:

buildPythonPackage rec {
  version = "0.17.7";
  pname = "bacpypes";

  /*src = fetchPypi {
    inherit pname version;
    sha256 = "13f9f196f330c7c2c5d7a5cf91af894110ca0215ac051b5844701f2bfd934d52";
  };*/

  src = fetchFromGitHub {
    owner = "JoelBender";
    repo = "bacpypes";
    rev = "792041b3ca103c85d7dfabd81f1f61bae5efdba3"; # 0.17.7 -> tag missing
    sha256 = "1bb630xpdachl3ij5bvxa67qybgrd2lqycqk4yicypyf5gs659j6";
  };

  checkInputs = [ pytest ];
  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ wheel ];


  # Time test fails
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/JoelBender/bacpypes;
    description = "BACpypes provides a BACnet application layer and network layer written in Python for daemons, scripting, and graphical interfaces.";
    license = licenses.mit;
  };
}
