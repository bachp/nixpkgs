{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-jupyter-builder,
  hatchling,
  jupyterlab,
  jupyter-server-proxy,
  nbconvert,
  pyzmq,
  traitlets,
  uv,
}:

buildPythonPackage rec {
  pname = "marimo-jupyter-extension";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "marimo_jupyter_extension";
    inherit version;
    hash = "sha256-AZGuHvhv+Xh+t4uQUNJNeSX786zu8I4gNX2fBFu8v1U=";
  };

  build-system = [
    hatch-jupyter-builder
    hatchling
    jupyterlab
  ];

  dependencies = [
    jupyter-server-proxy
    nbconvert
    pyzmq
    traitlets
    uv
  ];

  pythonImportsCheck = [ "marimo_jupyter_extension" ];

  meta = {
    description = "Jupyter extension to run marimo notebooks inside Jupyter";
    homepage = "https://github.com/marimo-team/marimo-jupyter-extension";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bachp ];
  };
}
