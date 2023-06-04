# When updating to a newer version, check if the version of `esp32-toolchain-bin.nix` also needs to be updated.
{ rev ? "v5.0"
#, hash ? "sha256-apKPPVgKFmwzybaU22PXVfegwbtw2oDTjuBGIwB2edk="
, hash ? "sha256-k2zVKXZCxeTJjON7hm3zWGqZDaOTWS5Ot4+MVnW89Q4="
#, hash ? "sha256-bMJQAQDmAnYxAwbjLhlbDiaVpdABhkdxGooYL1Ub8pE="
, stdenv
, lib
, fetchFromGitHub
#, fetchgit
, git
, esp-idf-python
}:
stdenv.mkDerivation rec {
  pname = "esp-idf";
  version = rev;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-idf";
    inherit rev hash;
    fetchSubmodules = true;
  };

  #src = fetchGit {
  #  url = "https://github.com/espressif/esp-idf";
  #  ref = "refs/tags/${rev}";
  #  submodules = true;
  #  shallow = true;
  #};

  #src = fetchgit {
  #  url = "https://github.com/espressif/esp-idf";
  #  inherit rev hash;
  #  fetchSubmodules = true;
  #  leaveDotGit = true;
  #};

  # This is so that downstream derivations will have IDF_PATH set.
  setupHook = ./setup-hook.sh;

  buildInputs = [ git ];

  propagatedBuildInputs = [
    # This is so that downstream derivations will run the Python setup hook and get PYTHONPATH set up correctly.
    esp-idf-python
  ];

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
    (cd $out && \
     git init -b master && \
     git config user.name "Nix Build" && \
     git config user.email "<build@nixos.org>" && \
     git commit --allow-empty -m "Version bump ${rev}" && \
     git tag ${rev})

    # Link the Python environment in so that in shell derivations, the Python
    # setup hook will add the site-packages directory to PYTHONPATH.
    ln -s ${esp-idf-python}/lib $out/
  '';
}
