{ pkgs ? import ../default.nix, tools ? [], extras ? {} }:
import ./base.nix {
  inherit pkgs extras;
  tools = with pkgs; [
    clang-esp32-elf-bin
    openocd-esp32-bin
    gdb-riscv-esp32-elf-bin
    gdb-xtensa-esp32-elf-bin
  ] ++ tools;
}
