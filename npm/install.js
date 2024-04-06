#!/usr/bin/env node
const fs = require("fs");
const { install } = require("./binary");

install();

// ------------------------------------------------------------------------------------------------
// templates: just copy
// ------------------------------------------------------------------------------------------------
const solc_0_7_decoder = fs.readFileSync("cli/templates/solc_0_7/Decoder.g.sol.hbs", "utf-8");
fs.writeFileSync("../../templates/solc_0_7/Decoder.g.sol.hbs", solc_0_7_decoder);

const solc_0_7_encoder = fs.readFileSync("cli/templates/solc_0_7/Encoder.g.sol.hbs", "utf-8");
fs.writeFileSync("../../templates/solc_0_7/Encoder.g.sol.hbs", solc_0_7_encoder);

const solc_0_8_decoder = fs.readFileSync("cli/templates/solc_0_8/Decoder.g.sol.hbs", "utf-8");
fs.writeFileSync("../../templates/solc_0_8/Decoder.g.sol.hbs", solc_0_8_decoder);

const solc_0_8_encoder = fs.readFileSync("cli/templates/solc_0_8/Encoder.g.sol.hbs", "utf-8");
fs.writeFileSync("../../templates/solc_0_8/Encoder.g.sol.hbs", solc_0_8_encoder);
// ------------------------------------------------------------------------------------------------