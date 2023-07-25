use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize, Clone, Default)]
pub struct FunctionArgObject {
    pub name: String,
    pub memory_type: bool,
    pub r#type: String,
    pub custom_type: bool,
    // 
}

#[derive(Debug, Deserialize, Serialize, Clone, Default)]
pub struct FunctionObject {
    pub args: Vec<FunctionArgObject>,
    // len
}

#[derive(Debug, Deserialize, Serialize, Clone, Default)]
pub struct ContractObject {
    pub solidity_filepath: String,
    pub contract_name: String,
    pub function_name: String,
    pub function: FunctionObject,
}
