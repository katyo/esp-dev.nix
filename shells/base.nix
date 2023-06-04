{ pkgs ? import ../default.nix, name ? "esp-shell", tools ? [], extras ? {} }:

pkgs.mkShell ({
  inherit name;

  buildInputs = tools;
} // extras)
