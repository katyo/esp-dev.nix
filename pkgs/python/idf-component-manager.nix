{ buildPythonPackage, fetchPypi,
  cachecontrol, cffi, click, colorama, future, packaging, pyyaml,
  requests, requests-file, requests-toolbelt, schema, six, tqdm }:
buildPythonPackage rec {
  pname = "idf_component_manager";
  version = "1.2.1";
  doCheck = false;
  propagatedBuildInputs = [
    cachecontrol cffi click colorama future packaging pyyaml
    requests requests-file requests-toolbelt schema six tqdm
  ] ++ cachecontrol.optional-dependencies.filecache;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lSqZEgVkSXLAbYuh01T70KB2q+/KmQhtWXejeRpF+9Y=";
  };
}
