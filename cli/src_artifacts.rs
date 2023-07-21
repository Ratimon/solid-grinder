use std::{fs, path::Path};

use path_slash::PathExt;
use regex::Regex;
use substring::Substring;
use walkdir::WalkDir;

use crate::types::{FunctionArgObject, FunctionObject, ContractObject};

struct ContractName {
    start: usize,
    end: usize,
    name: String,
}

static INTERNAL_TYPES: [&str; 103] = [
    "uint",
    "uint256",
    "uint8",
    "uint16",
    "uint24",
    "uint32",
    "uint40",
    "uint48",
    "uint56",
    "uint64",
    "uint72",
    "uint80",
    "uint88",
    "uint96",
    "uint104",
    "uint112",
    "uint120",
    "uint128",
    "uint136",
    "uint144",
    "uint152",
    "uint160",
    "uint168",
    "uint176",
    "uint184",
    "uint192",
    "uint200",
    "uint208",
    "uint216",
    "uint232",
    "uint240",
    "uint248",
    "uint256",
    "int",
    "int256",
    "int8",
    "int16",
    "int24",
    "int32",
    "int40",
    "int48",
    "int56",
    "int64",
    "int72",
    "int80",
    "int88",
    "int96",
    "int104",
    "int112",
    "int120",
    "int128",
    "int136",
    "int144",
    "int152",
    "int160",
    "int168",
    "int176",
    "int184",
    "int192",
    "int200",
    "int208",
    "int216",
    "int232",
    "int240",
    "int248",
    "int256",
    "bytes1",
    "bytes2",
    "bytes3",
    "bytes4",
    "bytes5",
    "bytes6",
    "bytes7",
    "bytes8",
    "bytes9",
    "bytes10",
    "bytes11",
    "bytes12",
    "bytes13",
    "bytes14",
    "bytes15",
    "bytes16",
    "bytes17",
    "bytes18",
    "bytes19",
    "bytes20",
    "bytes21",
    "bytes22",
    "bytes23",
    "bytes24",
    "bytes25",
    "bytes26",
    "bytes27",
    "bytes28",
    "bytes29",
    "bytes30",
    "bytes31",
    "bytes32",
    "string",
    "bytes",
    "address",
    "bool",
    "address payable",
];

fn is_custom_type(t: &str) -> bool {
    if INTERNAL_TYPES.contains(&t) {
        return false;
    }
    for i in INTERNAL_TYPES.map(|v| format!("{}[", v)) {
        if t.starts_with(i.as_str()) {
            return false;
        }
    }
    // TODO not full proof, name ufixed_myname will be considered non-custom
    if t.starts_with("ufixed") {
        return false;
    }
    if t.starts_with("fixed") {
        return false;
    }
    return true;
}
