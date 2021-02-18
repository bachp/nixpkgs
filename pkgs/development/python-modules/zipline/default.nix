{ lib
, buildPythonPackage
, fetchPypi
, cython
, numpy, scipy, pandas, pandas-datareader
, python-interface, iso3166, Logbook, sqlalchemy
, click, six, toolz, patsy, statsmodels
, multipledispatch, pytz, python-dateutil
, requests, alembic, h5py, tables
, bottleneck, iso4217, empyrical, bcolz
, networkx, numexpr, lru-dict, intervaltree, trading-calendars
}:

buildPythonPackage rec {
  pname = "zipline";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "043d0yb9k9pvy35sa601ijf6w99fqjhd802s1g6043sc6byvi8px";
  };

  # TODO: create proper patch
  postPatch = ''
    substituteInPlace etc/requirements.in \
          --replace 'pandas-datareader>=0.2.1,<0.9.0' 'pandas-datareader>=0.2.1' \
          --replace 'networkx>=1.9.1,<2.0' 'networkx>=1.9.1' \
          --replace 'pandas>=0.18.1,<=0.22' 'pandas>=0.18.1'
  '';

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [
    numpy scipy pandas pandas-datareader
    python-interface iso3166 Logbook sqlalchemy
    click six toolz patsy statsmodels
    multipledispatch pytz python-dateutil
    requests alembic h5py tables
    bottleneck iso4217 empyrical bcolz
    networkx numexpr lru-dict intervaltree
    trading-calendars
  ];

  # TODO: fix tests
  doCheck = false;
  pythonImportsCheck = [ "zipline" ];

  meta = with lib; {
    homepage = "https://zipline.io/";
    description = "Zipline is a Pythonic algorithmic trading library.";
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
  };
}
