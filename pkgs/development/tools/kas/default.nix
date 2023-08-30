{ lib, fetchFromGitHub, python3, testers, kas }:

python3.pkgs.buildPythonApplication rec {
  pname = "kas";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "siemens";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-AiI0PSxn0DSDc3+tNxGJFoA8ZfQS4nJhRazgj6zrXZA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "jsonschema>=2.5.0,<4" "jsonschema>=2.5.0" \
      --replace "PyYAML>=3.0,<6" "PyYAML>=3.0"
  '';

  propagatedBuildInputs = with python3.pkgs; [ setuptools kconfiglib jsonschema distro pyyaml ];

  doCheck = false;
  passthru.tests.version = testers.testVersion {
    package = kas;
    command = "${pname} --version";
  };

  meta = with lib; {
    homepage = "https://github.com/siemens/kas";
    description = "Setup tool for bitbake based projects";
    license = licenses.mit;
    maintainers = with maintainers; [ bachp ];
  };
}
