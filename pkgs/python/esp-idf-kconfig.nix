{ buildPythonPackage, fetchPypi,
  kconfiglib }:
buildPythonPackage rec {
  pname = "esp-idf-kconfig";
  version = "1.1.0";
  propagatedBuildInputs = [
    kconfiglib
  ];
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s8ZXt6cf5w2pZSxQNIs/SODAUvHNgxyQ+onaCa7UbFA=";
  };
}
