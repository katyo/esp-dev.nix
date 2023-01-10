{ pkgs ? import ../default.nix }:
import ./esp-idf.nix {
  inherit pkgs;
  toolchain = pkgs.gcc-xtensa-esp32-elf-bin;
}
