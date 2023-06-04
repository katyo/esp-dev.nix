{ pkgs ? import ../default.nix, tools ? [], extras ? {} }:
import ./base.nix {
  inherit pkgs extras;
  tools = with pkgs; [
    gcc-riscv-esp32-elf-bin
    openocd-esp32-bin
    gdb-riscv-esp32-elf-bin
  ] ++ tools;
}
