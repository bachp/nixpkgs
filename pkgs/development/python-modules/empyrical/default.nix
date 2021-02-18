{ lib, fetchFromGitHub, buildPythonPackage, pytestCheckHook, nose
, pandas, pandas-datareader, parameterized
}:

buildPythonPackage rec {
  pname = "empyrical";
  version = "0.5.5";

  # PyPi version doesn't include the test data
  src = fetchFromGitHub {
    rev = version;
    owner = "quantopian";
    repo = "empyrical";
    sha256 = "1cjplgh7kqqkav1l42r91h1s575xjv68s8awxyf5749wg1jwkfja";
  };

  propagatedBuildInputs = [ pandas pandas-datareader parameterized ];
  checkInputs = [ nose pytestCheckHook ];

  disabledTests = [
    "test_perf_attrib"  #TODO: fix test
  ];

  meta = with lib; {
    homepage = "https://github.com/quantopian/empyrical";
    description = "empyrical is a Python library with performance and risk statistics commonly used in quantitative finance";
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
  };
}
