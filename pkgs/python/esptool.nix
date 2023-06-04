{ buildPythonApplication, fetchPypi,
  bitstring, cryptography, ecdsa, pyserial, reedsolo }:
buildPythonApplication rec {
  pname = "esptool";
  #version = "4.4";
  version = "4.3";

  src = fetchPypi {
    inherit pname version;
    #hash = "sha256-is1N/nCBmxMChhrpKJQ4D7RwCzd/Wkc5R5pOwnbgslY=";
    hash = "sha256-A9ADEu7yWLr4P679C5ErIlHdBEAkLancsbGP517WFMM=";
  };

  propagatedBuildInputs = [
    bitstring cryptography ecdsa pyserial reedsolo
  ];

  # wrapPythonPrograms will overwrite esptool.py with a bash script,
  # but espefuse.py tries to import it. Since we don't add any binary paths,
  # use patchPythonScript directly.
  dontWrapPythonPrograms = true;
  postFixup = ''
    buildPythonPath "$out $pythonPath"
    for f in $out/bin/*.py; do
        echo "Patching $f"
        patchPythonScript "$f"
    done
  '';
}
