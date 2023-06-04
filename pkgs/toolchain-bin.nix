{ name, stdenv, lib, fetchurl, makeWrapper, buildFHSEnv, python27, python311 }:

let
  helper = import ./tools-helper.nix {};
  toolchain = helper.get-tool (helper.toolchain-name name) stdenv.system;
  version = helper.get-version (if name == "esp32ulp" then "ulp" else "esp") toolchain;
  pname = "${name}-toolchain";
  description = "${lib.toUpper name} compiler toolchain";
  homepage = "https://docs.espressif.com/projects/" +
    (if name == "esp8266" then "esp8266-rtos-sdk/en/latest" else "esp-idf/en/stable") +
    "/get-started/linux-setup.html";
  #python = python311;
  fhsEnv = buildFHSEnv {
    name = "${pname}-env";
    targetPkgs = pkgs: with pkgs; [
      zlib
      #python.pkgs.python # *-gdb-py support
    ];
    runScript = "";
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    inherit (toolchain) url sha256;
  };

  buildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    cp -r . $out
    for FILE in $(ls $out/bin); do
      FILE_PATH="$out/bin/$FILE"
      if [[ -x $FILE_PATH ]]; then
        mv $FILE_PATH $FILE_PATH-unwrapped
        makeWrapper ${fhsEnv}/bin/${pname}-env $FILE_PATH --add-flags "$FILE_PATH-unwrapped"
      fi
    done
  '';

  meta = with lib; {
    inherit description homepage;
    license = licenses.gpl3;
  };
}
