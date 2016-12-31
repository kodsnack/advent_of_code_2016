/*
 *  @author         Niklas Adolfsson
 *  @email          niklasadolfsson1@gmail.com
 *  @desc           AoC #7
 *  @date           2016-12-31
 */

extern crate regex;

use regex::Regex;
use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use std::path::Path;
use std::collections::HashMap;

fn main()
{
    let path = Path::new("input.txt");
    let lines = get_lines(path);
    print!("partA {} \n", part_a(&lines));
    // print!("partB {} \n",part_b(&strings));
}

fn part_a(lines: &Vec<String>) -> usize
{
    let mut count = 0;
    let re = Regex::new(r"\[\w+\]").unwrap();
    for line in lines
    {
        let out_brackets = re.splitn(line, 100).collect();
        let mut in_brackets: Vec<&str> = Vec::new();
        for caps in re.captures_iter(&line) {
            in_brackets.push(caps.at(0).unwrap());
        }
        if valid_sequence(&in_brackets) {continue;}
        if valid_sequence(&out_brackets) {count += 1;}
    }
    count
}

fn valid_sequence(seqs: &Vec<&str>) -> bool
{
    let mut found = false;
    'outer: for seq in seqs
    {
        let mut i = 0;
        while i < seq.len() - 3
        {
            let ch1 = seq.chars().nth(i).unwrap();
            let ch2 = seq.chars().nth(i+1).unwrap();
            let ch3 = seq.chars().nth(i+2).unwrap();
            let ch4 = seq.chars().nth(i+3).unwrap();
            /* abba */
            if is_abba((ch1, ch2, ch3, ch4))
            {
                found = true;
                break 'outer;
            }
            i += 1;
        }
    }
    found
}

fn is_abba(tuple: (char, char, char, char)) -> bool
{
    match tuple
    {
        (ch1, ch2, ch3, ch4) if ch1 == ch4 && ch3 == ch2 && ch1 != ch2 => true,
        (_, _, _, _) => false,
    }
}


fn part_b(strings: &Vec<String>) -> String
{
    "todo".to_string()
}

fn get_lines<P>(filename: P) -> Vec<String>
where P: AsRef<Path>,
      {
          let mut file = File::open(filename).expect("no such file");
          let mut buf = BufReader::new(file);
          buf.lines().map(|l| l.expect("Could not parse line")).collect()
      }

#[test]
fn tests()
{
    let path = Path::new("test_input.txt");
    let lines = get_lines(path);
    let test1 = part_a(&lines);
    assert!(test1 == 2);
}
