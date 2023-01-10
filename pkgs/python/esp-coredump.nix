{ buildPythonPackage, fetchPypi,
  construct, pygdbmi, esptool }:
buildPythonPackage rec {
  pname = "esp-coredump";
  version = "1.4.2";
  propagatedBuildInputs = [
    construct pygdbmi esptool
  ];
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sAZQOxgm/kzj4+XaO6UvvtZMr89eP3FER8jkSwDLkvM=";
  };
}
