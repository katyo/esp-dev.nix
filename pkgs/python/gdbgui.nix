{ buildPythonPackage, fetchPypi,
  #pip-tools, fetchFromGitHub,
  flask-socketio, flask-compress, pygdbmi, pygments, eventlet }:
buildPythonPackage rec {
  pname = "gdbgui";
  version = "0.15.1.0";
  doCheck = false;
  nativeBuildInputs = [
    #pip-tools
  ];
  propagatedBuildInputs = [
    flask-socketio flask-compress pygdbmi pygments eventlet
  ];
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YcD3om7N6yddm02It6/fjXDsVHG0Cs46fdGof0PMJXM=";
  };
  #src = fetchFromGitHub {
  #  owner = "cs01";
  #  repo = pname;
  #  rev = "v${version}";
  #  hash = "sha256-d8DDfASKIqLGngpsofdi2fskafOX4YbsfQGVt9bj9L4=";
  #};
  postPatch = ''
    #pip-compile requirements.in
    sed -i requirements.txt -e 's/==.*$//g'
  '';
}
