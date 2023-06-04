{ python310 }:
python310.withPackages (py: with py; let
    idf-component-manager = callPackage ./python/idf-component-manager.nix {};
    esptool = callPackage ./python/esptool.nix {};
    esp-coredump = callPackage ./python/esp-coredump.nix {};
    esp-idf-kconfig = callPackage ./python/esp-idf-kconfig.nix {};
    freertos-gdb = callPackage ./python/freertos-gdb.nix {};
    gdbgui = callPackage ./python/gdbgui.nix {};
in [
    # core: Core packages necessary for ESP-IDF
    setuptools
    click
    pyserial
    cryptography
    pyparsing
    pyelftools
    idf-component-manager
    esp-coredump
    esptool
    esp-idf-kconfig
    freertos-gdb

    # gdbgui: Packages for supporting debugging from web browser
    gdbgui

    # pytest: Packages for CI with pytest
    # ttfw: Packages for CI with ttfw
    # ci: Packages for ESP-IDF CI scripts
    # docs: Packages for building ESP-IDF documentation
])
