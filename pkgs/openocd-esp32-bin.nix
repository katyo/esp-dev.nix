{ stdenv, lib, fetchurl, makeWrapper, buildFHSUserEnv }:

let
  helper = import ./tools-helper.nix {};
  toolchain = helper.get-tool "openocd-esp32" stdenv.system;
  version = helper.get-version "ocd" toolchain;

  fhsEnv = buildFHSUserEnv {
    name = "esp32-openocd-env";
    targetPkgs = pkgs: with pkgs; [ zlib libusb1 ];
    runScript = "";
  };
in
stdenv.mkDerivation {
  pname = "openocd";
  inherit version;

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
        makeWrapper ${fhsEnv}/bin/esp32-openocd-env $FILE_PATH --add-flags "$FILE_PATH-unwrapped"
      fi
    done
  '';

  meta = with lib; {
    description = "ESP32 toolchain";
    homepage = https://docs.espressif.com/projects/esp-idf/en/stable/get-started/linux-setup.html;
    license = licenses.gpl3;
  };
}

