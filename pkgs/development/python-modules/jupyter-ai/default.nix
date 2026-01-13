{
  lib,
  buildPythonPackage,
  fetchPypi,

  # dependencies
  dask,
  deepmerge,
  faiss,
  importlib-metadata,
  jupyter-ai-magics,
  jupyter-server,
  pydantic,
  traitlets,

}:

buildPythonPackage rec {
  pname = "jupyter-ai";
  version = "2.31.7";
  format = "wheel";

  src = fetchPypi {
    pname = "jupyter_ai";
    inherit version format;
    python = "py3";
    dist = "py3";
    hash = "sha256-5z64fWd35PDBv51C6Q2jnV4kY7oAUQMfAvmGPlNcyVU=";
  };

  dependencies = [
    dask
    deepmerge
    faiss
    importlib-metadata
    jupyter-ai-magics
    jupyter-server
    pydantic
    traitlets
  ];

  # langchain 1.x API incompatible with jupyter-ai-magics which needs langchain 0.3.x
  #doCheck = false;

  pythonImportsCheck = [ ];

  meta = {
    changelog = "https://github.com/jupyterlab/jupyter-ai/blob/${src.tag}/CHANGELOG.md";
    description = "A generative AI extension for JupyterLab";
    homepage = "https://github.com/jupyterlab/jupyter-ai";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bachp ];
  };
}
