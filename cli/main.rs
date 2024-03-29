use std::path::Path;
use itertools::{Either, Itertools};

use clap::{builder::PossibleValuesParser, Parser, Subcommand};

use crate::types::ContractObject;

pub mod encoder;
pub mod decoder;
pub mod src_artifacts;
pub mod types;

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
#[command(propagate_version = true)]
struct Cli {
    #[arg(short, long)]
    root: Option<String>,

    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    // Generate Encoder Helper with source found
    GenDecoder(GenDecoderArgs),
    GenEncoder(GenEncoderArgs),
}

const SOL_VERSIONS: [&str; 2] = ["solc_0_7", "solc_0_8"];

#[derive(clap::Args)]
struct GenDecoderArgs {

    #[arg(short, long)]
    source: Option<String>,          // contracts/examples/uniswapv2/UniswapV2Router02.sol

    #[arg(short, long)]
    output: Option<String>,          // ./optimized

    #[arg(short, long)]
    contract_name: Option<String>,   // UniswapV2Router02

    #[arg(short, long)]
    function_name: Option<String>,   // addLiquidity

    #[arg(short, long, value_parser, num_args = 1, value_delimiter = ' ')]
    arg_bits: Vec<String>,

    #[arg(short = 'v', long, value_parser = PossibleValuesParser::new(SOL_VERSIONS), required(true), num_args = 1)]
    compiler_version: Option<String>, // solc_0_7", "solc_0_8"
}

#[derive(clap::Args)]
struct GenEncoderArgs {

    #[arg(short, long)]
    source: Option<String>,          // contracts/examples/uniswapv2/UniswapV2Router02.sol

    #[arg(short, long)]
    output: Option<String>,          // ./optimized

    #[arg(short, long)]
    contract_name: Option<String>,   // UniswapV2Router02

    #[arg(short, long)]
    function_name: Option<String>,   // addLiquidity

    #[arg(short, long, value_parser, num_args = 1, value_delimiter = ' ')]
    arg_bits: Vec<String>,

    #[arg(short = 'v', long, value_parser = PossibleValuesParser::new(SOL_VERSIONS), required(true), num_args = 1)]
    compiler_version: Option<String>, // solc_0_7", "solc_0_8"
}

fn main() {
    let cli = Cli::parse();


    match &cli.command {
        Some(command) => match command {
            Commands::GenDecoder(args) => {
                gen_decoder(
                    &cli.root,
                    &args.source,
                    &args.output,
                    &args.contract_name,
                    &args.function_name,
                    &args.arg_bits,
                    &args.compiler_version
                )
            }
            Commands::GenEncoder(args) => {
                gen_encoder(
                    &cli.root,
                    &args.source,
                    &args.output,
                    &args.contract_name,
                    &args.function_name,
                    &args.arg_bits,
                    &args.compiler_version
                )
            }
        },
        None => no_match_command(),
    }
}

fn gen_decoder(
    root: &Option<String>,
    source: &Option<String>,
    output: &Option<String>,
    contract_name: &Option<String>,
    function_name: &Option<String>,
    arg_bits: &Vec<std::string::String>,
    compiler_version : &Option<String>
) {
    let (contract, name, generated_directory_path) = get_data(root, source, output, contract_name, function_name, arg_bits);
    decoder::generate_decoder( contract, name, &generated_directory_path, compiler_version.as_deref().unwrap_or("solc_0_8"));
}

fn gen_encoder(
    root: &Option<String>,
    source: &Option<String>,
    output: &Option<String>,
    contract_name: &Option<String>,
    function_name: &Option<String>,
    arg_bits: &Vec<std::string::String>,
    compiler_version : &Option<String>
) {

    let (contract, name, generated_directory_path) = get_data(root, source, output, contract_name, function_name, arg_bits);
    encoder::generate_encoder( contract, name, &generated_directory_path, compiler_version.as_deref().unwrap_or("solc_0_8"));

}

fn get_data<'a>(
    root: &Option<String>,
    source: &Option<String>,
    output: &Option<String>,
    contract_name: &'a Option<String>,
    function_name: &Option<String>,
    arg_bits: &Vec<std::string::String>
) -> (ContractObject,&'a str, String) {

    let root_directory = root.as_deref().unwrap_or(".");
    let source_directory = source.as_deref().unwrap_or("contracts/examples/uniswapv2/UniswapV2Router02.sol");
    let contract_name = contract_name.as_deref().unwrap_or("UniswapV2Router02");
    let function_name = function_name.as_deref().unwrap_or("addLiquidity");

    let (successes, _): (Vec<_>, Vec<_>) = arg_bits.iter().partition_map(|i| match i.parse::<u16>() {
        Ok(v) => Either::Left(v),
        Err(_) => Either::Right(i.to_string()),
    });

    let bits: Result<Vec<u16>, String> = if successes.iter().all(|bit| bit % 8 == 0 && bit <= &256) {
        Ok(successes)
    } else {
        Err("Some elements are not divisible by 8 or greater than 256.".to_string())
    };

    let contract: types::ContractObject = src_artifacts::get_contract(root_directory, source_directory, contract_name, function_name, bits.unwrap()).unwrap();
    let generated_directory = output.as_deref().unwrap_or("optimized");
    // 
    let generated_directory_path_buf = Path::new(root_directory).join(generated_directory);
    let generated_directory_path = generated_directory_path_buf.to_str().unwrap().to_string();

    (contract, contract_name, generated_directory_path)
}

fn no_match_command() {
    println!("'no match command'")
}