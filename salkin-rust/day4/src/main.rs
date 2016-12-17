#[macro_use]
extern crate clap;
use clap::App;

use std::ops::Add;
use std::io::prelude::*;
use std::fs::File;
use std::io::{self, BufReader};

extern crate input;
use input::filereader;
use input::cli;

fn main() {

    //cli::init_cli("cli.yaml");
    ////cli::get_str_value("file");

    let mut v = filereader::read_file("input.txt");
    let mut count = 0;
    let mut sectorSum: u32;
    sectorSum = 0;
    while v.len() > 0 {
      let mut sectorId = 0;
      let is = is_room(v.pop().unwrap(), &mut sectorId);
      if is {
          count += 1;
          sectorSum += sectorId;
      } else {
          println!("Not real room");
      }
    }   
    println!("Amount real rooms: {}, sectorSum: {}", count, sectorSum);
}

fn is_room(s: String, sector: &mut u32) -> bool {
  let temp: Vec<&str> = s.rsplitn(2, '-').collect();
  if temp.len() != 2 {
      return false;
  }
  let mut chars: Vec<u32> = Vec::with_capacity(250);
  for i in 0..250 {
      chars.push(0);
  }
  let mut ch = String::from(String::from(temp[1]).trim_matches('-'));
  for c in ch.as_bytes() {
      let mut val = match chars.get_mut(usize::from(*c)) {
          Some(v) => v,
          None => continue,
      };
      *val += 1;
  }
  let code = getCode(String::from(temp[0]), false);
  let codeVec = code.as_bytes();


  /* Check that amount is in correct order */
  let mut lastVal = 0;
  let mut lastChar = 0;
  for (index, code_byte) in codeVec.iter().enumerate() {
      println!("Byte count {}", chars[usize::from(*code_byte)]);
      if index == 0 {
          lastChar = *code_byte;
          lastVal = chars[usize::from(*code_byte)];
          continue;
          
      }
      if chars[usize::from(*code_byte)] > lastVal {
          println!("Wrong count");
          return false;
      }


      /* if same amount check that atically */
      if chars[usize::from(*code_byte)] == lastVal {
          if *code_byte < lastChar  {
              println!("not alphabetically");
              return false;
          }
      }
      if lastChar == *code_byte {
          return false;
      }
      if chars[usize::from(*code_byte)] == 0 {
          return false;
      }

      lastVal = chars[usize::from(*code_byte)];
      lastChar = *code_byte;
  }


  let sectorStr = getCode(String::from(temp[0]), true);
  *sector = sectorStr.parse::<u32>().unwrap();
  return true;
  
}

fn getCode(s: String, sector: bool) -> String {
    let v: Vec<&str> = s.split("[").collect();
    let mut s = String::new();
    if v.len() != 2 {
        return String::from("");
    }

    let mut code = String::from(v[1]);
    println!("Room code: {}", code);
    if sector == true {
        return String::from(v[0]);
    }
    return String::from(code.trim_matches(']'));
    
}
