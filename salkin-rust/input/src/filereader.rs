
use std::io::prelude::*;

use std::fs::File;
use std::io::{self,BufReader};

struct FileReader {

}


pub fn read_file(s: &str) -> Vec<String> {
     let f = match File::open(s) {
         Ok(file) => file,
         Err(..) => panic!("File not found {}", s),
     };
   let reader = BufReader::new(f);
   let mut s = String::new();
   let mut v: Vec<String> = Vec::new();
   for line in reader.lines() {
       v.push(line.unwrap());
   }
   return v
 }
