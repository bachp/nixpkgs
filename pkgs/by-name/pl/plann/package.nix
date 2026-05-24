{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "plann";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uQ/a7umBr42k06Wv1d7jsI/EQf4SRYSgJmBbHx569ag=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  dependencies = with python3Packages; [
    caldav
    click
    pyyaml
    sortedcontainers
    tzlocal
  ];

  pythonImportsCheck = [ "plann" ];

  meta = {
    description = "Command-line CalDAV client for adding and browsing calendar items and tasks";
    homepage = "https://github.com/pycalendar/plann";
    changelog = "https://github.com/pycalendar/plann/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bachp ];
    mainProgram = "plann";
  };
})
