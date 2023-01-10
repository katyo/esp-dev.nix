{ ... }:
let
  host-archs = {
    "x86_32-linux" = "linux-i686";
    "x86_64-linux" = "linux-amd64";
    "armel-linux" = "linux-armel";
    "armhf-linux" = "linux-armhf";
    "aarch64-linux" = "linux-arm64";
    "x86_64-darwin" = "macos";
    "aarch64-darwin" = "macos-arm64";
    "x86-windows" = "win32";
    "x86_64-windows" = "win64";
  };

  load-json = file: builtins.fromJSON (builtins.readFile file);

  last-elem = list: builtins.elemAt list ((builtins.length list) - 1);

  esp8266-rtos-sdk-tools = load-json ./esp8266-rtos-sdk/tools.json;
  esp-idf-tools = load-json ./esp-idf/tools.json;

  all-tools = esp8266-rtos-sdk-tools.tools ++ esp-idf-tools.tools;

  find-tool = name:
    let found-tools = builtins.filter (fields: fields.name == name) all-tools;
    in if 0 == builtins.length found-tools
       then builtins.throw "No '${name}' tool found."
       else last-elem found-tools;

  host-arch = host-system:
    if builtins.hasAttr host-system host-archs
    then host-archs.${host-system}
    else builtins.throw "Host system '${host-system}' not supported.";

  select-tool = host-system: found-tool: (last-elem found-tool.versions).${host-arch host-system};

  get-tool = name: host-system: select-tool host-system (find-tool name);

  get-version = tool-type: got-tool: last-elem (builtins.match {
    esp = "^.*-esp-([^-]+).*$";
    ulp = "^.*-elf-(\d+[^-]+).*$";
    ocd = "^.*/v([^/]+)/.*$";
    gcc = "^.*-gcc(\d+[^-]+).*$";
  }.${tool-type} got-tool.url);

  toolchain-names = {
    esp8266 = "xtensa-lx106-elf";
    esp32 = "xtensa-esp32-elf";
    esp32s2 = "xtensa-esp32s2-elf";
    esp32c3 = "riscv32-esp-elf";
    esp32ulp = "esp32ulp-elf";
  };

  toolchain-name = target-name:
    if builtins.hasAttr target-name toolchain-names
    then toolchain-names.${target-name}
    else builtins.throw "Toolchain for '${target-name}' not found.";
in {
  inherit get-tool get-version toolchain-name;
}
