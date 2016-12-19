extern crate input;
use input::cli;
use input::filereader;

use std::slice;
use std::str;
use std::collections::HashMap;

const USAGE: &'static str = "
Usage:
  day7 [--file=<FILE>]
  day7 (-h | --help)
Options: 
  -h --help   show help
  --file=<FILE>     Input file to use
";

fn main() {
    let c = cli::init_cli(USAGE);
    let file = c.get_arg("--file");
    println!("Uing file {}", file );
    let mut f = filereader::read_file(file.as_str());

    let mut count = 0;
    for ip in f {
        if is_tls(ip) {
            count += 1;
        }
    }
    println!("TLS enabled IPs: {}", count);
}

fn is_tls(s: String) ->bool {
   let sp: Vec<&str> = s.split(|c| c == '[' || c == ']').collect();

   let mut isAbba = false;
   for (index, st) in sp.iter().enumerate() {
       if index %2 == 1 {
           if check_abba(String::from(*st)) {
               return false;
           }
       } else {
           if check_abba(String::from(*st)) {
               isAbba = true;
           }
       }

   }
   return isAbba;
}

fn check_abba(s: String) -> bool{
    let tr = s.as_str();
    let chars = tr.as_bytes();

    let mut start = 0;
    let mut done = false;
    while !done {
        if(start+3 >= tr.len()) {
            break;
        }
        if chars[start] == chars[start+3] {
            /* Outer ok */
            if( chars[start+1] == chars[start+2]) {
                /*Inner ok */
                if chars[start] != chars[start+1] {
                    return true;
                }
            }
        }
        start += 1;
    }
    return false;
}

