#!/usr/bin/env node
const fs = require("fs");
const path = require("path");
const { install } = require("./binary");

install();

// ------------------------------------------------------------------------------------------------
// templates: just copy
// ------------------------------------------------------------------------------------------------
const solc_0_7_decoder = fs.readFileSync("cli/templates/solc_0_7/Decoder.g.sol.hbs", "utf-8");
let targetDir = path.join(__dirname, "/../../templates/solc_0_7/");
if (!fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir, { recursive: true });
}
fs.writeFileSync(path.join(targetDir, "Decoder.g.sol.hbs"), solc_0_7_decoder);

const solc_0_7_encoder = fs.readFileSync("cli/templates/solc_0_7/Encoder.g.sol.hbs", "utf-8");
targetDir = path.join(__dirname, "/../../templates/solc_0_7/");
if (!fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir, { recursive: true });
}
fs.writeFileSync(path.join(targetDir, "Encoder.g.sol.hbs"), solc_0_7_encoder);

const solc_0_8_decoder = fs.readFileSync("cli/templates/solc_0_8/Decoder.g.sol.hbs", "utf-8");
targetDir = path.join(__dirname, "/../../templates/solc_0_8/");
if (!fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir, { recursive: true });
}
fs.writeFileSync(path.join(targetDir, "Decoder.g.sol.hbs"), solc_0_8_decoder);

const solc_0_8_encoder = fs.readFileSync("cli/templates/solc_0_8/Encoder.g.sol.hbs", "utf-8");
targetDir = path.join(__dirname, "/../../templates/solc_0_8/");
if (!fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir, { recursive: true });
}
fs.writeFileSync(path.join(targetDir, "Encoder.g.sol.hbs"), solc_0_8_encoder);