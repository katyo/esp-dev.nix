{ buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "freertos-gdb";
  version = "1.0.1";
  doCheck = false;
  propagatedBuildInputs = [
  ];
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2pQNajOItyjpuHkZ8Ky87bSKPo752GV23bMQaTegYZE=";
  };
}
