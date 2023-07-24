use std::{fs, path::Path, path::PathBuf, task::Context};

use handlebars::Handlebars;

use crate::types::ContractObject;

pub fn generate_decoder(
    contract: ContractObject,
    generated_directory: &str,
) {

    let mut handlebars = Handlebars::new();
    handlebars.set_strict_mode(true);

    handlebars
        .register_template_string(
            "Decoder.g.sol",
            include_str!("templates/Decoder.g.sol.hbs"),
        )
        .unwrap();


    let folder_path_buf = Path::new(generated_directory).join("decoder");
    let folder_path = folder_path_buf.to_str().unwrap();

    fs::create_dir_all(folder_path).expect("create folder");

    write_if_different(
        &format!("{}/Decoder.g.sol", folder_path),
        format!(
            "{}",
            handlebars
                .render("Decoder.g.sol", &contract)
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

use handlebars::{ Helper, HelperResult, JsonRender, Output, RenderContext};

fn memory_type(
    h: &Helper,
    _: &Handlebars,
    _: &Context,
    _rc: &mut RenderContext,
    out: &mut dyn Output,
) -> HelperResult {
    let param = h.param(0).unwrap();

    let str_value = param.value().render();
    if str_value.eq("string") {
        out.write("memory")?;
    }

    Ok(())
}