use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize, Clone, Default)]
pub struct FunctionArgObject {
    pub arg_name: String,
    pub instruction: String,
    pub memory_type: bool,
    pub r#type: String,
    pub custom_type: bool,
    pub address_type: bool,
    pub uint256_type: bool,
    pub packed_bit_size: u16,
    pub is_final: bool
}

#[derive(Debug, Deserialize, Serialize, Clone, Default)]
pub struct EncodingObject {
    pub instruction: String,
    pub r#type: String,
    pub address_type: bool,
    pub uint256_type: bool,
    pub packed_bit_size: u16,
    pub packed_byte_size: u16,
}

#[derive(Debug, Deserialize, Serialize, Clone, Default)]
pub struct FunctionObject {
    pub args: Vec<FunctionArgObject>,
    pub encodings: Vec<EncodingObject>,
}

#[derive(Debug, Deserialize, Serialize, Clone, Default)]
pub struct ContractObject {
    pub solidity_filepath: String,
    pub contract_name: String,
    pub function_name: String,
    pub function: FunctionObject,
}
