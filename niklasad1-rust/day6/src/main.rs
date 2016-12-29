/*
 *  @author         Niklas Adolfsson
 *  @email          niklasadolfsson1@gmail.com
 *  @desc           AoC #6
 *  @date           2016-12-29
 */

use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use std::path::Path;
use std::collections::HashMap;

fn main()
{
    let path = Path::new("input.txt");
    let strings = get_strs(path);
    print!("partA {} \n", part_a(&strings));
    print!("partB {} \n",part_b(&strings));
}

fn part_a(strings: &Vec<String>) -> String
{
    let mut s: String = String::new();
    /* push most frequent char of each postion to the final string */
    for str in strings { s.push(get_most_freq_ch(str.to_string())); }
    s
}

fn part_b(strings: &Vec<String>) -> String
{
    let mut s: String = String::new();
    /* push least freq char of each postion to the final string */
    for str in strings { s.push(get_least_likely_ch(str.to_string())); }
    s
}

fn get_most_freq_ch(string: String) -> char
{
    let table = construct_letter_count(string);
    let mut ch = '_';
    let mut freq = 0;
    for (letter, count) in table.iter()
    {
        if freq < *count
        {
            ch = *letter; freq = *count
        }
    }
    ch
}

fn get_least_likely_ch(string: String) -> char
{
    let table = construct_letter_count(string);
    let mut ch = '_';
    let mut freq = usize::max_value();
    for (letter, count) in table.iter()
    {
        if freq > *count
        {
            ch = *letter; freq = *count
        }
    }
    ch
}

fn construct_letter_count(string: String) -> HashMap<char, usize>
{
    let mut table: HashMap<char, usize> = HashMap::new();

    /* insert letters and counters to a hashmap */
    for ch in string.chars()
    {
        let counter = table.entry(ch).or_insert(0);
        *counter += 1;
    }
    table
}


fn get_strs<P>(filename: P) -> Vec<String>
where P: AsRef<Path>,
      {
          let file = File::open(filename).expect("no such file");
          let buf = BufReader::new(file);
          let lines: Vec<String> = buf.lines().map(|l| l.expect("Could not parse line")).collect();
          /* assume all lines are of equal length */
          let row_len = lines[0].len();
          let mut strings: Vec<String> = Vec::new();
          /* create vector of strings for each vertical position */
          for _ in 0..row_len  {strings.push("".to_string()); }

          /* construct strings */
          for line in lines
          {
              for (i, c) in line.chars().enumerate() { strings[i].push(c); }
          }
          strings
      }

#[test]
fn tests()
{
    let path = Path::new("test_input.txt");
    let lines = get_strs(path);
    let test1 = part_a(&lines);
    assert!(test1 == "easter");
}
