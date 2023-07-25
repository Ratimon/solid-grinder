use std::path::{Path};

use clap::{Parser, Subcommand};

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
    /// Generate Encoder Helper with source found
    GenDecoder(GenDecoderArgs),
}

#[derive(clap::Args)]
struct GenDecoderArgs {

    #[arg(short, long)]
    source: Option<String>,   // ./src/original.sol

    #[arg(short, long)]
    output: Option<String>,    // ./optimized

    #[arg(short, long)]
    contract_name: Option<String>,   // .contractName

    #[arg(short, long)]
    function_name: Option<String>,   // addLiquidity

    #[arg(short, long, value_parser, num_args = 1, value_delimiter = ' ')]
    arg_bits: Vec<String>,

    // TODO handling error for boolean
    // TODO handling error for unsupport types now only support address and uint
}

fn main() {
    let cli = Cli::parse();


    match &cli.command {
        Some(command) => match command {
            Commands::GenDecoder(args) => {
                gen_decoder(&cli.root, &args.source, &args.output, &args.contract_name, &args.function_name, &args.arg_bits)
            }
        },
        None => test(),
    }
}

fn gen_decoder(
    root: &Option<String>,
    source: &Option<String>,
    output: &Option<String>,
    contract_name: &Option<String>,
    function_name: &Option<String>,
    arg_bits: &Vec<std::string::String>
) {
    let root_directory = root.as_deref().unwrap_or(".");
    let source_directory = source.as_deref().unwrap_or("contracts/examples/uniswapv2/UniswapV2Router02.sol");
    let contract_name = contract_name.as_deref().unwrap_or("UniswapV2Router02");
    let function_name = function_name.as_deref().unwrap_or("addLiquidity");
    let bits: Vec<i8> = arg_bits
        .iter()
        .map(|s| s.parse::<i8>().unwrap()) 
        .collect();

    let contract = src_artifacts::get_contract(root_directory, source_directory, contract_name, function_name, bits).unwrap();

    let generated_directory = output.as_deref().unwrap_or("optimized");
    let generated_directory_path_buf = Path::new(root_directory).join(generated_directory);
    let generated_directory_path = generated_directory_path_buf.to_str().unwrap();

    decoder::generate_decoder( contract, generated_directory_path);
}

fn test() {
    println!("'solid-grinder'")
}
