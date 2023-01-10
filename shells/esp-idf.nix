{ pkgs ? import ../default.nix, toolchain }:

pkgs.mkShell {
  name = "esp-idf";

  buildInputs = with pkgs; [
    toolchain
    openocd-esp32-bin
    esp-idf
    esptool

    # Tools required to use ESP-IDF.
    git
    wget
    gnumake

    flex
    bison
    gperf
    udev
    libusb
    pkgconfig

    cmake
    ninja

    ncurses5
  ];
}
