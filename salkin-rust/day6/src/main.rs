extern crate input;
use input::cli;
use input::filereader;

use std::slice;
use std::str;
use std::collections::HashMap;

const USAGE: &'static str = "
Usage:
  day6 [--file=<FILE>]
  day6 (-h | --help)
Options: 
  -h --help   show help
  --file=<FILE>     Input file to use
";

fn main() {
    let c = cli::init_cli(USAGE);
    let file = c.get_arg("--file");
    println!("Uing file {}", file );
    let mut f = filereader::read_file(file.as_str());

    parseMessages(&f);
}

fn parseMessages(v: &Vec<String>) {
    let mut columns: Vec<HashMap<char, u32>> = Vec::new();
    for (index, s) in v.iter().enumerate() {
        /* Create the Hashmap of chars */
        let mut chars = s.chars();
        let mut ch = chars.next();
        let mut j = 0;
        while ch != None {

            if (columns.len() <= j) {
                let mut map: HashMap<char, u32> = HashMap::new();
                columns.push(map);
            }
            let mut tempColumn = &mut columns[j];
            let zero = 0;
            let cur_char = ch.unwrap();
            {
                let mut newamount = 0;
                {
                 let &mut amount;
                 amount = match tempColumn.get_mut(&cur_char) {
                    Some(value) => value,
                    None => &zero,
                };
                 newamount = *amount;
                }

                let clon = cur_char.clone();
                let mut newam = 1;
                if newamount != 0 {
                    newam = newamount + 1;
                }
                tempColumn.insert(clon, newam);
                j += 1;
                ch = chars.next();
            }   
        }
    }
    println!("Vec len {}", columns.len());
    let code = getCode(&columns);
    println!("Code is {}", code)
}

fn getCode(v: &Vec<HashMap<char,u32>>) -> String {
    let mut code = String::new();
    let mut highestchar: char = '-';
    for column in v.iter() {
        let mut highestCount: u32 = 0;
        for (ch, count) in column {
            if *count > highestCount {
                highestCount = *count;
                highestchar = ch.clone();
            }
        }
        code.push(highestchar);
    }
    return code;
}


