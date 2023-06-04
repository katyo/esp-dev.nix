final: prev:
let tool-pkg = prev.callPackage ./pkgs/tool-pkg.nix;
in {
  gcc-riscv-esp32-elf-bin = tool-pkg { type = "gcc"; target = "esp32c3"; };
  gcc-xtensa-esp32-elf-bin = tool-pkg { type = "gcc"; target = "esp32"; };
  gcc-xtensa-esp32s2-elf-bin = tool-pkg { type = "gcc"; target = "esp32s2"; };
  gcc-xtensa-esp32s3-elf-bin = tool-pkg { type = "gcc"; target = "esp32s3"; };
  gcc-esp32ulp-elf-bin = tool-pkg { type = "ulp"; target = "esp32"; };

  clang-esp32-elf-bin = tool-pkg { type = "clang"; target = "any"; };

  openocd-esp32-bin = tool-pkg { type = "openocd"; target = "esp32"; };

  gdb-riscv-esp32-elf-bin = tool-pkg { type = "gdb"; target = "esp32c3"; };
  gdb-xtensa-esp32-elf-bin = tool-pkg { type = "gdb"; target = "esp32"; };

  esp-idf-python = prev.callPackage ./pkgs/python-env.nix { };

  esp-idf = prev.callPackage ./pkgs/esp-idf { };

  esp-tool = final.esp-idf-python.pkgs.callPackage ./pkgs/python/esptool.nix { };

  # ESP8266
  gcc-xtensa-lx106-elf-bin = tool-pkg { type = "gcc"; target = "esp8266"; };

  # Note: These are currently broken in flake mode because they fetch files
  # during the build, making them impure.
  crosstool-ng-xtensa = prev.callPackage ./pkgs/crosstool-ng-xtensa.nix { };
  gcc-xtensa-lx106-elf = prev.callPackage ./pkgs/gcc-xtensa-lx106-elf { };
}
