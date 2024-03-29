use std::{fs, path::Path};

use handlebars::Handlebars;

use crate::types::ContractObject;

pub fn generate_decoder(
    contract: ContractObject,
    contract_name: &str,
    generated_directory: &str,
    compiler_version: &str,
) {
    let mut handlebars = Handlebars::new();
    handlebars.set_strict_mode(true);

    let generated_name: String = format!("{}_DataDecoder.g.sol", contract_name);

    let template_path = format!("cli/templates/{}/Decoder.g.sol.hbs", compiler_version);
    let template_content = fs::read_to_string(&template_path)
        .unwrap_or_else(|err| panic!("Failed to read template file {}: {}", template_path, err));

    handlebars
        .register_template_string(
            &generated_name,
            &template_content
        )
        .unwrap();

    let folder_path_buf = Path::new(generated_directory).join("decoder");
    let folder_path = folder_path_buf.to_str().unwrap();

    fs::create_dir_all(folder_path).expect("create folder");

    write_if_different(
        &format!("{}/{}_Decoder.g.sol", folder_path, contract_name),
        format!(
            "{}",
            handlebars
                .render(&generated_name, &contract)
                .unwrap()
        ),
    );
    
}
    
fn write_if_different(path: &String, content: String) {

    let result = fs::read(path);
    let same = match result {
        Ok(existing) => String::from_utf8(existing).unwrap().eq(&content),
        Err(_e) => false,
    };

    if !same {
        println!("writing new files...");
        fs::write(path, content).expect("could not write file");
    }
}