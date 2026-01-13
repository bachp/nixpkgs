{
  lib,
  buildPythonPackage,
  fetchPypi,

  # dependencies
  tensorflow,
  tf-keras,
}:

buildPythonPackage rec {
  pname = "tensorflow-model-optimization";
  version = "0.8.0";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_model_optimization";
    inherit version format;
    hash = "sha256-UDA+btbQfBp4ASFfXMhU2tOI6o3jGeRnRso1eJ5O57M=";
  };

  dependencies = [
    tensorflow
    tf-keras
  ];

  pythonImportsCheck = [ "tensorflow_model_optimization" ];

  meta = with lib; {
    description = "A suite of tools that users, both novice and advanced can use to optimize machine learning models for deployment and execution";
    homepage = "https://github.com/tensorflow/model-optimization";
    changelog = "https://github.com/tensorflow/model-optimization/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
