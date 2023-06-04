{ pkgs ? import ../default.nix, tools ? [], extras ? {} }:
import ./base.nix {
  inherit pkgs extras;
  tools = with pkgs; [
    gcc-xtensa-lx106-elf-bin
    esptool
  ] ++ tools;
}
