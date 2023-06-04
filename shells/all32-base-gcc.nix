{ pkgs ? import ../default.nix, tools ? [], extras ? {} }:
import ./base.nix {
  inherit pkgs extras;
  tools = with pkgs; [
    gcc-riscv-esp32-elf-bin
    gcc-xtensa-esp32-elf-bin
    gcc-xtensa-esp32s2-elf-bin
    gcc-xtensa-esp32s3-elf-bin
    gcc-esp32ulp-elf-bin
    openocd-esp32-bin
    gdb-riscv-esp32-elf-bin
    gdb-xtensa-esp32-elf-bin
  ] ++ tools;
}
