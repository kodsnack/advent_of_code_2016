#[macro_use]
extern crate clap;
use clap::App;

use std::ops::Add;
use std::io::prelude::*;
use std::fs::File;
use std::io::{self, BufReader};

type Direction = i32;

const LEFT: i32 = 1;
const UP: i32 = 2;
const RIGHT: i32 = 3;
const DOWN: i32 = 4;
const UNKNOWN: i32 = 5;

#[derive(Copy, Clone)]
struct Location {
     x: i32,
     y: i32,
    code: u32,
}



impl Location {
    pub fn new() -> Location {
        return Location{ x:0, y:0, code: 0 };
    }

    fn getCode(&self) -> u32 {
        match self.x {
            -1 => {
                match self.y  {
                    -1 => 7,
                    0 => 4,
                    1 => 1,
                    _ => 0,
                }
            },
            0 => {
                match self.y {
                    -1 => 8,
                    0 => 5,
                    1 => 2,
                    _ => 0,
                }
            },
            1 => {
                match self.y {
                    -1 => 9,
                    0 => 6,
                    1 => 3,
                    _ => 0,
                }
            },
            _ => 0,

        }
    }

    fn up(&mut self) {
        if(self.y != 1) {
            self.y +=1;
        }
    }

    fn down(&mut self){
        if(self.y != -1) {
            self.y -= 1;
        }
    }

    fn left(&mut self) {
        if(self.x != -1) {
            self.x -= 1;
        }
    }

    fn right(&mut self) {
        if(self.x != 1) {
            self.x += 1;
        }
    }



}




fn main() {

    let yaml = load_yaml!("cli.yaml");
    let matches = App::from_yaml(yaml).get_matches();

    let input = matches.value_of("moves").unwrap_or("");
    if input == "" {
        println!("Give moves");
        return;
    }
    let mut input = read_file();
    let mut startLoc = Location{x:0, y:0, code:0};
    for n in 0..input.len() { 
      let blocks = make_move(&input.get(n).unwrap(), startLoc);
      println!("Code  {}", blocks.getCode());
      startLoc = blocks;
    }
}

fn read_file() -> Vec<String> {
    let f = match File::open("input.txt") {
        Ok(file) => file,
        Err(..) => panic!("File not found"),
    };
  let reader = BufReader::new(f);
  let mut s = String::new();
  let mut v: Vec<String> = Vec::new();
  for line in reader.lines() {
      v.push(line.unwrap());
  }
  return v
}



fn make_move( moves: &String, l: Location ) -> Location {
    let mut chars = moves.chars();
    let mut m = chars.next();
    let mut loc = l;
    while (m != None) {
        match m.unwrap() {
            'U' => loc.up(),
            'D' => loc.down(),
            'L' => loc.left(),
            'R' => loc.right(),
            _ => println!("Śome"),
        }
        m = chars.next();


    }
    
    return loc

}
