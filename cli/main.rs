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
    templates: Option<String>, // ./templates/Encoder.g.sol.hbs

    #[arg(short, long)]
    sources: Option<String>,   // ./templates/original.sol

    #[arg(short, long)]
    output: Option<String>,    // ./optimized
}

fn main() {
    let cli = Cli::parse();


    match &cli.command {
        Some(command) => match command {
            Commands::GenDecoder(args) => {
                gen_decoder(&cli.root, &args.templates, &args.sources, &args.output)
            }
        },
        None => test(),
    }
}

fn gen_decoder(
    root: &Option<String>,
    templates: &Option<String>,
    sources: &Option<String>,
    output: &Option<String>,
) {
    let root_folder = root.as_deref().unwrap_or(".");
    let sources_folder = sources.as_deref().unwrap_or("src");
    let generated_folder = output.as_deref().unwrap_or("optimized");

    // let contracts = src_artifacts::get_contract(root_folder, sources_folder);
    // let generated_folder_path_buf = Path::new(root_folder).join(generated_folder);
    // let generated_folder_path = generated_folder_path_buf.to_str().unwrap();

}

fn test() {
    println!("'solid-grinder'")
}
