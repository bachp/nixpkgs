{
  lib,
  buildPythonPackage,
  fetchPypi,

  # dependencies
  tf-keras,
  keras,
}:

buildPythonPackage rec {
  pname = "tensorflow-hub";
  version = "0.16.1";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_hub";
    inherit version format;
    hash = "sha256-4QwYSz0I2ur62hH/6i3UZ4FyW2vvAfrR901mNK0FMR8=";
  };

  dependencies = [
    tf-keras
    keras
  ];

  pythonImportsCheck = [ "tensorflow_hub" ];

  meta = with lib; {
    description = "TensorFlow Hub is a library for publication, discovery, and consumption of reusable parts of machine learning models";
    homepage = "https://github.com/tensorflow/hub";
    changelog = "https://github.com/tensorflow/hub/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bachp ];
  };
}
