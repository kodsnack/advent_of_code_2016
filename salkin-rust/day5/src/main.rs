extern crate input;
extern crate crypto;
use input::cli;
use input::filereader;

use crypto::md5;
use crypto::digest::Digest;
use std::slice;
use std::str;

const USAGE: &'static str = "
Usage:
  day5 [--file=<FILE>]
  day5 (-h | --help)
Options: 
  -h --help   show help
  --file=<FILE>     Input file to use
";

fn main() {
    let c = cli::init_cli(USAGE);
    let file = c.get_arg("--file");
    println!("Uing file {}", file );
    let mut f = filereader::read_file(file.as_str());

    let s = f.get_mut(0).unwrap();
    let mut i = 0;
    let mut password: String = "".to_string();
    let mut done = false;
    while !done {
      let mut toTest = s.clone();
      let inte = i.to_string();
      let mut sec = toTest + inte.as_str();
      let res = getMd5(sec.as_str());
      let fiveZeros = check_res(&res);
      if fiveZeros {
        println!("Digit: {}", i);
        let mut res_t = res.chars();
        
        password.push(res_t.nth(5).unwrap());
        if password.len() == 8 {
            done = true;
        }
      }
      i += 1;
    }
    println!("Password is {}", password);
}

fn getMd5(s: &str) -> String{

    let mut m5 = md5::Md5::new();
    let c = String::from(s);
    m5.input_str(s);
    let result = m5.result_str();
    return result;
}

fn check_res(s: &String) -> bool {
    let mut ptr = s.chars();
    for i in 0..5 {
        if ptr.next() != Some('0') {
            return false;
        }
    }
    return true;
}
