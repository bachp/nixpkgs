{ buildPythonPackage
, lib
, fetchFromGitHub
, pytestCheckHook
, rustPlatform
}:

buildPythonPackage rec {
  pname = "zenoh-python";
  version = "0.6.0-beta.1";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-python";
    rev = version;
    sha256 = "sha256-6aOSxmWp3NNVRDnmqz4knDgV2s0keozMEPblcBd9Dh4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-xGHwIxNJMMxWKev7IJSeNvUaEhEOu8T2vtG2C/9y0q0=";
  };

  format = "pyproject";

  nativeBuildInputs = [
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  pythonImportsCheck = [ "zenoh" ];

  meta = with lib; {
    description = "Python API for zenoh";
    homepage = "https://zenoh.io/";
    license = with licenses; [ asl20 epl10 ];
    maintainers = with maintainers; [ bachp ];
  };
}
