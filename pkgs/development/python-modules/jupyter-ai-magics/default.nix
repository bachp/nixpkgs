{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,

  # dependencies
  boto3,
  click,
  cohere,
  huggingface-hub,
  importlib-metadata,
  ipython,
  jsonpath-ng,
  langchain,
  langchain-anthropic,
  langchain-aws,
  langchain-community,
  langchain-google-genai,
  langchain-mistralai,
  langchain-ollama,
  langchain-openai,
  pydantic,
  pythonOlder,
  tomlkit,
}:

buildPythonPackage rec {
  pname = "jupyter-ai-magics";
  version = "2.31.7";
  format = "wheel";

  src = fetchPypi {
    pname = "jupyter_ai_magics";
    inherit version format;
    python = "py3";
    dist = "py3";
    hash = "sha256-QrCybRhkvZjPbGowNzPUIYaAHrFHejuFrLOW4qlLWrE=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "langchain"
    "langchain-community"
  ];

  dependencies = [
    click
    importlib-metadata
    ipython
    jsonpath-ng
    langchain
    langchain-community
    pydantic
    tomlkit
  ];

  passthru.optional-dependencies = {
    all = [
      boto3
      cohere
      huggingface-hub
      langchain-anthropic
      langchain-aws
      langchain-google-genai
      langchain-mistralai
      langchain-ollama
      langchain-openai
    ];
  };

  pythonImportsCheck = [ "jupyter_ai_magics" ];

  meta = {
    changelog = "https://github.com/jupyterlab/jupyter-ai/blob/${src.tag}/CHANGELOG.md";
    description = "A generative AI extension for JupyterLab - Magics component";
    homepage = "https://github.com/jupyterlab/jupyter-ai";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.jupyter;
  };
}
