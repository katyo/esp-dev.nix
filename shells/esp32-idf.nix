{ pkgs ? import ../default.nix }:
import ./esp-idf.nix {
  inherit pkgs;
  tools = with pkgs; [
    gcc-xtensa-esp32-elf-bin
  ];
}
