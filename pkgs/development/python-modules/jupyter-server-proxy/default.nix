{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-jupyter-builder,
  hatchling,
  aiohttp,
  jupyter-server,
  jupyterlab,
  simpervisor,
  tornado,
  traitlets,
}:

buildPythonPackage rec {
  pname = "jupyter-server-proxy";
  version = "4.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyter_server_proxy";
    inherit version;
    hash = "sha256-5XMuucgQwMqpl/kKLxX30Jr2OOfuqcZ+tcQ+nB8OEVc=";
  };

  build-system = [
    hatch-jupyter-builder
    hatchling
    jupyterlab
  ];

  dependencies = [
    aiohttp
    jupyter-server
    simpervisor
    tornado
    traitlets
  ];

  pythonImportsCheck = [ "jupyter_server_proxy" ];

  meta = {
    description = "Jupyter server extension to supervise and proxy web services";
    homepage = "https://github.com/jupyterhub/jupyter-server-proxy";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
