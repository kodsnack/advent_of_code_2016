#[macro_use]
extern crate clap;
use clap::App;

use std::ops::Add;

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
}

impl Location {
    pub fn new() -> Location {
        Location{ x:0, y:0 }
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
     
    let blocks = make_move(input);

    println!("Moved  {}", blocks.x.abs() + blocks.y.abs());
}

fn make_move( moves: &str ) -> Location {
    let mut v: Vec<Location> = Vec::new();
    let mut currentDir = UP;
    let mut loc = Location::new();
    let a: Vec<&str> = moves.split(", ").collect();
    for value in a {
        println!("value = {}", value);
        
        let loc = loc + moveTo(value, &mut currentDir);
        v.push(loc);
        let last = v.last().unwrap();
        if v.len() > 1 {
            let sameloc = findsame(&v, &last);
            //TODO: same loc is 0,0
            if sameloc.x != 0 && sameloc.y != 0 {
               println!("First same loc at: x:{}, y:{} ", sameloc.x, sameloc.y); 
    
            }
        }
    }
    let borrow = v.pop().unwrap();
    return borrow;
}

fn findsame(v: &Vec<Location>, l: &Location) -> Location {
    for e in v {
        if *e == *l {
            return Location {x: l.x, y: l.y};
        }
    }
    Location {x:0, y:0}
}

impl Add for Location {
    type Output = Location;

    fn add(self, other: Location) -> Location {
        Location { x: self.x + other.x, y: self.y + other.y }
    }
}

impl PartialEq for Location {
    fn eq(&self, other: &Location) -> bool {
       (self.x == other.x && self.y == other.y) 
    }
}

fn moveTo( dir: &str, current: &mut Direction ) -> Location {
    
    let nextDir = dir.chars().next().unwrap_or('N');
    *current = match nextDir {
            'R' => calcNext(current, RIGHT),
            'L' => calcNext(current, LEFT),
            _ =>  calcNext(current, UNKNOWN),
        };
    let var: i32;
   unsafe { 
        var =  dir.slice_unchecked(1, dir.len()).parse().unwrap();
    }
    let loc = match *current {
        RIGHT => Location {x: var, y: 0},
        LEFT => Location {x: -(var), y: 0},
        UP => Location {x:0 , y: var},
        DOWN => Location {x:0, y: -(var)},
        _ => Location {x:0, y:0},
    };
    return loc;
}

fn calcNext(cur: &Direction, moveTo: Direction) -> Direction {
    let mut newDir = UNKNOWN;
    if moveTo == LEFT {
        newDir = *cur - 1;
        if newDir < LEFT {
            newDir = DOWN;
        }
    }
    if moveTo == RIGHT {
        newDir = *cur + 1;
        if newDir > DOWN {
            newDir = LEFT;
        }
    }
    newDir
}
