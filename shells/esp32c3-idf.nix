{ pkgs ? import ../default.nix }:
import ./esp-idf.nix {
  inherit pkgs;
  toolchain = pkgs.gcc-riscv32-esp32c3-elf-bin;
}
