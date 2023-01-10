{ buildPythonPackage, fetchPypi,
  bitstring, cryptography, ecdsa, pyserial, reedsolo }:
buildPythonPackage rec {
  pname = "esptool";
  version = "4.4";
  propagatedBuildInputs = [
    bitstring cryptography ecdsa pyserial reedsolo
  ];
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-is1N/nCBmxMChhrpKJQ4D7RwCzd/Wkc5R5pOwnbgslY=";
  };
}
