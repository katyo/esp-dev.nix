# When updating to a newer version, check if the version of `esp32-toolchain-bin.nix` also needs to be updated.
{ rev ? "v5.0" # "v4.4.1"
, hash ? "sha256-apKPPVgKFmwzybaU22PXVfegwbtw2oDTjuBGIwB2edk="
  # "sha256-k2zVKXZCxeTJjON7hm3zWGqZDaOTWS5Ot4+MVnW89Q4="
  # "sha256-4dAGcJN5JVV9ywCOuhMbdTvlJSCrJdlMV6wW06xcrys="
, stdenv
, lib
, fetchFromGitHub
, fetchgit
, python310
}:

let
  #src = fetchFromGitHub {
  #  owner = "espressif";
  #  repo = "esp-idf";
  #  inherit rev hash;
  #  fetchSubmodules = true;
  #};

  #src = fetchGit {
  #  url = "https://github.com/espressif/esp-idf";
  #  ref = "refs/tags/${rev}";
  #  submodules = true;
  #  shallow = true;
  #};

  src = fetchgit {
    url = "https://github.com/espressif/esp-idf";
    inherit rev hash;
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  pythonEnv = python310.withPackages (py: with py; let
    idf-component-manager = callPackage ../python/idf-component-manager.nix {};
    esptool = callPackage ../python/esptool.nix {};
    esp-coredump = callPackage ../python/esp-coredump.nix {};
    esp-idf-kconfig = callPackage ../python/esp-idf-kconfig.nix {};
    freertos-gdb = callPackage ../python/freertos-gdb.nix {};
    gdbgui = callPackage ../python/gdbgui.nix {};
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
  ]);
in
stdenv.mkDerivation rec {
  pname = "esp-idf";
  version = rev;

  inherit src;

  # This is so that downstream derivations will have IDF_PATH set.
  setupHook = ./setup-hook.sh;

  propagatedBuildInputs = [
    # This is so that downstream derivations will run the Python setup hook and get PYTHONPATH set up correctly.
    pythonEnv
  ];

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/

    # Link the Python environment in so that in shell derivations, the Python
    # setup hook will add the site-packages directory to PYTHONPATH.
    ln -s ${pythonEnv}/lib $out/
  '';
}
