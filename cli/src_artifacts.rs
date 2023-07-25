use std::{fs, path::Path};

use regex::Regex;

use crate::types::{FunctionArgObject, FunctionObject, ContractObject};

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
    bits: Vec<i8>
) -> Result<ContractObject, String>  {

    let match_comments = Regex::new(r#"(?ms)(".*?"|'.*?')|(/\*.*?\*/|//[^\r\n]*$)"#).unwrap();
    let match_strings = Regex::new(r#"(?m)(".*?"|'.*?')"#).unwrap();

    // function\s+(\w+)\s*\(\s*([^)]*)\s*\)
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

    let args: Vec<FunctionArgObject> = if parsable_function_string.eq("") {
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

                let mut args_type = components.get(0).unwrap().to_string();

                let custom_type = is_custom_type(&args_type);

                let second = components.get(1).unwrap();
                let mut memory_type = false;
                if second.eq("memory") {
                    memory_type = true;
                }

                let name = if memory_type {
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
                    name: name.to_string(),
                    memory_type,
                    r#type: args_type,
                    custom_type,
                };
            })
            .collect()
    };

    // println!(
    //     "{:?} {:?} {:?} {:?} ",
    //     args[0].name, args[0].memory_type, args[0].r#type,  args[0].custom_type
    // );
    // println!(
    //     "{:?} {:?} {:?} {:?} ",
    //     args[1].name, args[1].memory_type, args[1].r#type,  args[1].custom_type
    // );
    // println!(
    //     "{:?} {:?} {:?} {:?} ",
    //     args[2].name, args[2].memory_type, args[2].r#type,  args[2].custom_type
    // );
    // println!(
    //     "{:?} {:?} {:?} {:?} ",
    //     args[3].name, args[3].memory_type, args[3].r#type,  args[3].custom_type
    // );
    // println!(
    //     "{:?} {:?} {:?} {:?} ",
    //     args[4].name, args[4].memory_type, args[4].r#type,  args[4].custom_type
    // );

    if args.iter().any(|arg| arg.r#type != "address" && arg.r#type != "uint256") {
        return Err("We currently only support `address` and`uint256`type. Please modify your data type to either address or uint256  ".to_string())
    }

    match args.len() {
        args_length if args_length == bits.len() => {
            let contract: ContractObject = ContractObject {
                solidity_filepath: String::from(directory_path),
                contract_name: String::from(contract_name),
                function_name: String::from(function_name),
                function: FunctionObject { args },
            };
            return Ok(contract);
        },
        _ => return Err("Please specify the same amount of bits as argument number.".to_string())
    }

}