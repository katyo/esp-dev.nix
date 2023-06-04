{ pkgs ? import ../default.nix, name ? "esp-shell", tools ? [] }:
import ./base.nix {
  inherit name pkgs;
  extras = {
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib/libclang.so";
    #LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [ udev ]);
  };
  tools = with pkgs; [
    #openocd-esp32-bin
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
