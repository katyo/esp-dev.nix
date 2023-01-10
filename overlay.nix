final: prev:
{
  # ESP32C3
  gcc-riscv32-esp32c3-elf-bin = prev.callPackage ./pkgs/toolchain-bin.nix { name = "esp32c3"; };
  # ESP32S2
  gcc-xtensa-esp32s2-elf-bin = prev.callPackage ./pkgs/toolchain-bin.nix { name = "esp32s2"; };
  # ESP32
  gcc-xtensa-esp32-elf-bin = prev.callPackage ./pkgs/toolchain-bin.nix { name = "esp32"; };
  # ESP32ULP
  gcc-esp32ulp-elf-bin = prev.callPackage ./pkgs/toolchain-bin.nix { name = "esp32ulp"; };

  openocd-esp32-bin = prev.callPackage ./pkgs/openocd-esp32-bin.nix { };

  esp-idf = prev.callPackage ./pkgs/esp-idf { };

  # ESP8266
  gcc-xtensa-lx106-elf-bin = prev.callPackage ./pkgs/toolchain-bin.nix { name = "esp8266"; };

  # Note: These are currently broken in flake mode because they fetch files
  # during the build, making them impure.
  crosstool-ng-xtensa = prev.callPackage ./pkgs/crosstool-ng-xtensa.nix { };
  gcc-xtensa-lx106-elf = prev.callPackage ./pkgs/gcc-xtensa-lx106-elf { };
}
