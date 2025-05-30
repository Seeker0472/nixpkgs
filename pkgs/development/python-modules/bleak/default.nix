{
  lib,
  async-timeout,
  bluez,
  buildPythonPackage,
  dbus-fast,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "bleak";
  version = "0.22.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hbldh";
    repo = "bleak";
    tag = "v${version}";
    hash = "sha256-kPeKQcJETZE6+btQsmCgb37yRI2Klg0lZ1ZIrm8ODow=";
  };

  postPatch = ''
    # bleak checks BlueZ's version with a call to `bluetoothctl --version`
    substituteInPlace bleak/backends/bluezdbus/version.py \
      --replace \"bluetoothctl\" \"${bluez}/bin/bluetoothctl\"
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    async-timeout
    dbus-fast
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bleak" ];

  meta = with lib; {
    description = "Bluetooth Low Energy platform agnostic client";
    homepage = "https://github.com/hbldh/bleak";
    changelog = "https://github.com/hbldh/bleak/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oxzi ];
  };
}
