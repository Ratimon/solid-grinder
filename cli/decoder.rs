use std::{fs, path::Path};

use handlebars::Handlebars;

use crate::types::ContractObject;

pub fn generate_decoder(
    contract: ContractObject,
    contract_name: &str,
    generated_directory: &str,
) {
    let mut handlebars = Handlebars::new();
    handlebars.set_strict_mode(true);

    let generated_name: String = format!("{}_DataDecoder.g.sol", contract_name);
    handlebars
        .register_template_string(
            &generated_name,
            include_str!("templates/Decoder.g.sol.hbs"),
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