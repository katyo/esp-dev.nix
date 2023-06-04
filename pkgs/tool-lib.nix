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

  description-type-regex = {
    toolchain = "^[Tt][Oo]{2}[Ll][Cc][Hh][Aa][Ii][Nn][ ]+.*$";
    gcc = "^.*[ ]+[Gg][Cc]{2}$";
    clang = "^.*[ ]+[Cc][Ll][Aa][Nn][Gg]$";
    ulp = "^.*[ ]+[Uu][Ll][Pp][ ]+.*$";
    gdb = "^[Gg][Dd][Bb][ ]+.*$";
    openocd = "^[Oo][Pp][Ee][Nn][Oo][Cc][Dd][ ]+.*$";
    cmake = "^[Cc][Mm][Aa][Kk][Ee][ ]+.*$";
    ninja = "^[Nn][Ii][Nn][Jj][Aa][ ]+.*$";
  };

  filter-type = type: tools:
    builtins.filter (fields: !builtins.isNull
      (builtins.match description-type-regex.${type} fields.description))
      tools;

  filter-target = target: tools:
    builtins.filter (fields:
      if builtins.hasAttr "supported_targets" fields
      then (builtins.any (sup_target:
        sup_target == "all" || sup_target == target || target == "any") fields.supported_targets)
      else if target == "esp8266" then fields.name == "xtensa-lx106-elf"
      else target == "any")
      tools;

  version-from-url = url: last-elem (builtins.sort (a: b: (builtins.stringLength a) < (builtins.stringLength b))
    (builtins.map (v: builtins.elemAt v 0) (builtins.filter (v: !builtins.isString v)
      (builtins.split "([\._0-9]+)" url))));

  host-arch-from-system = system:
    if builtins.hasAttr system host-archs
    then host-archs.${system}
    else builtins.throw "Host system '${system}' not supported.";

  get-tool = type: target: host:
    let tool = last-elem (filter-target target
      (filter-type type all-tools));
        ver = (last-elem tool.versions).${host-arch-from-system host};
    in {
      inherit (tool) name description;
      version = version-from-url ver.url;
      homepage = tool.info_url;
      inherit (ver) url sha256 size;
    };
in {
  inherit get-tool;
}
