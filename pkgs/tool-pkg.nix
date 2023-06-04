{ stdenv, lib, fetchurl, autoPatchelfHook, type, target, pkgs, ... }:
let
  tool-lib = import ./tool-lib.nix;
  tool = tool-lib.get-tool type target stdenv.system;

in stdenv.mkDerivation {
  pname = tool.name;
  inherit (tool) version;

  src = fetchurl {
    inherit (tool) url sha256;
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = with pkgs;
    (lib.optional (type == "gcc" || type == "clang") [ stdenv.cc.cc ]) ++
    (lib.optional (type == "clang") [ zlib libxml2.dev ]) ++
    (lib.optional (type == "openocd") [ zlib libusb1 udev ]) ++
    (lib.optional (type == "gcc" && target == "esp8266") [ python27 ]) ++
    (lib.optional (type == "gdb") [ python311 ]);

  configurePhase = "true";

  buildPhase = (lib.optionalString (type == "gdb") ''
    cd bin
    for gdb in ls *-gdb-*; do
      if [[ "$gdb" == *-gdb-3.11 ]]; then
        gdbp=`echo "$gdb" | sed 's/-3.11$//g'`
        mv "$gdb" "$gdbp"
        for sfx in esp32 esp32s2 esp32s3; do
          gdbq=`echo "$gdbp" | sed "s/esp-/$sfx-/g"`
          if [ -f "$gdbq" ]; then
            rm -f "$gdbq"
            ln -s "$gdbp" "$gdbq"
          fi
        done
      else
        rm -f "$gdb"
      fi
    done
    cd -
  '') + "true";

  installPhase = ''
    install -d -m0755 $out
    cp -r . $out
  '';

  meta = with lib; {
    inherit (tool) description homepage;
    license = licenses.gpl3;
  };
}
