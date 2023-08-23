use std::{collections::HashSet, fs, path::Path};

use regex::Regex;

use crate::types::{FunctionArgObject, EncodingObject, FunctionObject, ContractObject};

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

pub fn get_contract(
    root_directory: &str,
    source_directory: &str,
    contract_name: &str,
    function_name: &str,
    bits: Vec<u16>
) -> Result<ContractObject, String>  {

    let match_comments = Regex::new(r#"(?ms)(".*?"|'.*?')|(/\*.*?\*/|//[^\r\n]*$)"#).unwrap();
    let match_strings = Regex::new(r#"(?m)(".*?"|'.*?')"#).unwrap();

    let pattern: String = format!(
        r#"(?m)function\s+{}\s*\(\s*([^)]*)\s*\)"#,
        regex::escape(function_name)
    );

    let match_function_name = Regex::new(&pattern).unwrap();

    let directory_path_buf = Path::new(root_directory).join(source_directory);
    let directory_path = directory_path_buf.to_str().unwrap();

    let data = fs::read_to_string(directory_path).expect("Unable to read file");
    let data = match_comments.replace_all(&data, "");
    let data = match_strings.replace_all(&data, "");

    let function_string =
    match match_function_name.captures(&data) {
        Some(found) => match found.get(1) {
            Some(function) => {
                let result = function.as_str().trim();
                if result.eq("") {
                    None
                } else {
                    Some(result.to_string())
                }
            }
            None => None,
        },
        None => None,
    };

    let parsable_function_string =
    function_string.clone().unwrap_or("".to_string());

    let mut args: Vec<FunctionArgObject> = if parsable_function_string.eq("") {
        Vec::new()
    } else {
        let args_split = parsable_function_string.split(",");
        args_split
            .map(|s| {
                let components = s
                    .trim()
                    .split(" ")
                    .map(|v| v.to_string())
                    .collect::<Vec<String>>();

                let mut args_type: String = components.get(0).unwrap().to_string();

                let instruction: String = match args_type.as_str() {
                    "address" => "lookupAddress".to_string(),
                    "uint256" => "deserializeAmount".to_string(),
                    _ => "deserializeAmount".to_string(),
                };

                let address_type: bool = args_type == "address";
                let uint256_type: bool = args_type == "uint256";

                let custom_type = is_custom_type(&args_type);

                let second = components.get(1).unwrap();
                let mut memory_type = false;
                if second.eq("memory") {
                    memory_type = true;
                }

                let arg_name = if memory_type {
                    components.get(2).unwrap()
                } else {
                    if args_type.eq("address") && second.eq("payable") {
                        args_type = format!("{} payable", args_type);
                        components.get(2).unwrap()
                    } else {
                        second
                    }
                };

                return FunctionArgObject {
                    arg_name: arg_name.to_string(),
                    instruction: instruction,
                    memory_type,
                    r#type: args_type,
                    address_type,
                    uint256_type,
                    custom_type,
                    packed_bit_size: 0,
                    is_final: false,
                };
            })
            .collect()
    };

    if args.iter().any(|arg| arg.r#type != "address" && arg.r#type != "uint256") {
        return Err("We currently only support `address` and`uint256`type. Please modify your data type to either address or uint256".to_string())
    }

    if let Some(final_arg) = args.last_mut() {
        final_arg.is_final = true;
    }

    for (arg, &bit) in args.iter_mut().zip(bits.iter()) {
        // Modify the packed_bit_size field by adding the corresponding value from bits
        arg.packed_bit_size = bit;
    }

    let mut encodings: Vec<EncodingObject> = args
        .iter()
        .map(|arg| EncodingObject {
            instruction: arg.instruction.clone(),
            r#type: arg.r#type.clone(),
            address_type: arg.address_type.clone(), 
            uint256_type: arg.uint256_type.clone() ,
            packed_bit_size: arg.packed_bit_size,
            packed_byte_size: arg.packed_bit_size / 8,
            is_first: false,
        })
        .collect();

    if let Some(first_arg) = encodings.get_mut(0) {
        first_arg.is_first = true;
    }

    let mut seen = HashSet::new();
    encodings.retain(|encoding| seen.insert((encoding.instruction.clone(), encoding.packed_bit_size)));

    match args.len() {
        args_length if args_length == bits.len() => {

            let contract: ContractObject = ContractObject {
                solidity_filepath: String::from(directory_path),
                contract_name: String::from(contract_name),
                function_name: String::from(function_name),
                function: FunctionObject {
                    args: args,
                    encodings: encodings
                },
            };
            return Ok(contract);
        },
        _ => return Err("Please specify the same amount of bits as argument number.".to_string())
    }

}