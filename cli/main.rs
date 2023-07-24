use std::path::{Path, PathBuf};

use handlebars::Handlebars;
use regex::Regex;
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
    template: Option<String>, // ./templates/Decoder.g.sol.hbs

    #[arg(short, long)]
    source: Option<String>,   // ./src/original.sol

    #[arg(short, long)]
    contract_name: Option<String>,   // .contractName

    #[arg(short, long)]
    function_name: Option<String>,   // addLiquidity

    #[arg(short, long)]
    output: Option<String>,    // ./optimized
}

fn main() {
    let cli = Cli::parse();


    match &cli.command {
        Some(command) => match command {
            Commands::GenDecoder(args) => {
                gen_decoder(&cli.root, &args.template,  &args.source, &args.contract_name, &args.function_name, &args.output)
            }
        },
        None => test(),
    }
}

fn gen_decoder(
    root: &Option<String>,
    template: &Option<String>,
    source: &Option<String>,
    contract_name: &Option<String>,
    function_name: &Option<String>,
    output: &Option<String>,
) {
    let root_directory = root.as_deref().unwrap_or(".");
    let source_directory = source.as_deref().unwrap_or("contracts/examples/uniswapv2/UniswapV2Router02.sol");
    let contract_name = contract_name.as_deref().unwrap_or("UniswapV2Router02");
    let function_name = function_name.as_deref().unwrap_or("addLiquidity");
    let generated_directory = output.as_deref().unwrap_or("optimized");

    

    let contract = src_artifacts::get_contract(root_directory, source_directory, contract_name, function_name);
    let generated_directory_path_buf = Path::new(root_directory).join(generated_directory);
    let generated_directory_path = generated_directory_path_buf.to_str().unwrap();

    let template_paths = if let Some(template) = template {
        template
            .split(",")
            .map(|v| PathBuf::from(v))
            .collect::<Vec<PathBuf>>()
    } else {
        Vec::new()
    };

    decoder::generate_decoder( contract, &template_paths, generated_directory_path);
}

fn test() {
    println!("'solid-grinder'")
}
