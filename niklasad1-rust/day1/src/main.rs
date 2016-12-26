/*
 *  @desc           AoC #1 - find distance to target.
 *  @author         Niklas Adolfsson
 *  @email          niklasadolfsson1@gmail.com
 *  @date           2016-12-24
 */

extern crate regex;
use std::error::Error;
use std::fs::File;
use std::io::prelude::*;
use std::path::Path;
use regex::Regex;
use std::collections::LinkedList;

fn main()
{
    /* Read input to a string */
    let path = Path::new("input.txt");
    // let path = Path::new("test_2.txt");
    let display = path.display();
    let mut file = match File::open(&path)
    {
        Err(why) => panic!("couldn't open {}: {}", display,
                           why.description()),
        Ok(file) => file,
    };

    let mut s = String::new();

    match file.read_to_string(&mut s)
    {
        Err(why) => panic!("couldn't read {}: {}", display,
                           why.description()),
        Ok(_) => print!(""),
    }


    /* Split the string into a vector of operations */
    let v: Vec<&str> = s.split(", ").collect();
    let mut visited = LinkedList::new(); 
    let mut state = (0i32, 0i32);
    let mut dir = 0;
    let mut visited_twice = false;
  
    visited.push_back(state);

    for i in 0..v.len() {
        let re = Regex::new(r"(^[:alpha:]{1})(\d+)").unwrap();
        let mut dummy: char = 'e';
        let mut new_pos: i32 = 0;

        for cap in re.captures_iter(v[i]) {
            let s  = cap.at(1).unwrap_or("");
            dummy = s.chars().nth(0).unwrap();
            new_pos = cap.at(2).unwrap_or("").parse().unwrap();
        }

        dir =
            if dummy == 'R' {
                (dir+1) % 4
            }
            else {
                (dir+3) % 4
            };
       
        /* need to add each one iterative to cope with partB  */
        for j in 0..new_pos {
            state =  match dir
            {
                0 => (state.0 + 1, state.1),
                1 => (state.0, state.1 + 1),
                2 => (state.0 - 1, state.1),
                3 => (state.0, state.1 - 1),
                _ => panic!("pattern matching direction error"),
            };
           
            if visited.contains(&state) && !visited_twice {
                visited_twice = true;
                print!("partB dist = {} \n", state.0.abs()+state.1.abs());
            }
            else
            {
                visited.push_back(state);
            };
        }

    }
    print!("partA dist = {} \n", state.0.abs()+state.1.abs());
}
