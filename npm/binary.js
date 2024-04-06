const { Binary } = require("./binary-install");
const os = require("os");
const {join} = require("path");

const error = msg => {
  console.error(msg);
  process.exit(1);
};

const { version: actualVersion, name, repository } = require("./package.json");
const version = "1.1.0";

const supportedPlatforms = [
  {
    TYPE: "Windows_NT",
    ARCHITECTURE: "x64",
    RUST_TARGET: "x86_64-pc-windows-msvc",
    BINARY_NAME: "solid-grinder.exe"
  },
  {
    TYPE: "Linux",
    ARCHITECTURE: "x64",
    RUST_TARGET: "x86_64-unknown-linux-musl",
    BINARY_NAME: "solid-grinder"
  },
  {
    TYPE: "Darwin",
    ARCHITECTURE: "x64",
    RUST_TARGET: "x86_64-apple-darwin",
    BINARY_NAME: "solid-grinder"
  },
  {
    TYPE: "Darwin",
    ARCHITECTURE: "arm64",
    RUST_TARGET: "aarch64-apple-darwin",
    BINARY_NAME: "solid-grinder"
  }
];

const getPlatformMetadata = () => {
  const type = os.type();
  const architecture = os.arch();

  for (let supportedPlatform of supportedPlatforms) {
    if (
      type === supportedPlatform.TYPE &&
      architecture === supportedPlatform.ARCHITECTURE
    ) {
      return supportedPlatform;
    }
  }

  error(
    `Platform with type "${type}" and architecture "${architecture}" is not supported by ${name}.\nYour system must be one of the following:\n\n${JSON.stringify(supportedPlatforms, null, 2)}`
  );
};

const getBinary = () => {
  const platformMetadata = getPlatformMetadata();
  // the url for this binary is constructed from values in `package.json`
  const url = `${repository.url}/releases/download/v${version}/${name}_v${version}_${platformMetadata.RUST_TARGET}.tar.gz`;
  return new Binary(platformMetadata.BINARY_NAME, url, {installDirectory: join(__dirname, "bin")});
};

const run = () => {
  const binary = getBinary();
  binary.run();
};

const install = () => {
  const binary = getBinary();
  binary.install();
};

module.exports = {
  install,
  run
};