{ pkgs ? import ../default.nix, toolchain }:

pkgs.mkShell {
  name = "esp";

  LIBCLANG_PATH = "${pkgs.libclang.lib}/lib/libclang.so";

  #LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [ udev ]);

  buildInputs = with pkgs; [
    toolchain
    openocd-esp32-bin
    #cargo-espflash

    python310
    python310.pkgs.pip
    python310.pkgs.virtualenv
    libclang.lib

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
