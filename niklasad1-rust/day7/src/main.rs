/*
 *  @author         Niklas Adolfsson
 *  @email          niklasadolfsson1@gmail.com
 *  @desc           AoC #7
 *  @date           2017-01-02
 */
extern crate regex;

use regex::Regex;
use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use std::path::Path;
use std::iter::FromIterator;
use std::collections::HashMap;

fn main()
{
    let path = Path::new("input.txt");
    let lines = get_lines(path);
    print!("partA {} \n", part_a(&lines));
    print!("partB {} \n",part_b(&lines));
}

fn part_a(lines: &Vec<String>) -> usize
{
    let mut count = 0;
    let re = Regex::new(r"\[\w+\]").unwrap();
    for line in lines
    {
        let out_brackets = re.replace_all(line, ";;;;");
        let mut in_brackets = String::new();
        for caps in re.captures_iter(&line) {
            in_brackets.push_str("[[[");
            in_brackets.push_str(caps.at(0).unwrap());
            in_brackets.push_str("]]]");
        }
        if valid_abba(&in_brackets) {continue;}
        if valid_abba(&out_brackets) {count += 1;}
    }
    count
}

fn part_b(lines: &Vec<String>) -> usize
{
    let mut count = 0;
    let re = Regex::new(r"\[\w+\]").unwrap();
    for line in lines
    {
        let out_brackets = re.replace_all(line, ";;;;");
        let mut in_brackets = String::new();
        for caps in re.captures_iter(&line) {
            in_brackets.push_str("[[[");
            in_brackets.push_str(caps.at(0).unwrap());
            in_brackets.push_str("]]]");
        }
        if valid_aba(&in_brackets, &out_brackets) { count += 1;}
    }
    count
}

fn valid_aba(in_brackets: &String, out_brackets: &String) -> bool
{
    let mut result = false;
    let mut i = 0;
    let mut in_candidates: Vec<String> = Vec::new();

    while i < in_brackets.len() - 2
    {
        let mut s: Vec<char> = Vec::new();
        s.push(in_brackets.chars().nth(i).unwrap());
        s.push(in_brackets.chars().nth(i+1).unwrap());
        s.push(in_brackets.chars().nth(i+2).unwrap());

        if s[0] == s[2] && s[0] != s[1]
        {
            in_candidates.push(String::from_iter(s));
        }
        i += 1;
    }

    i = 0;
    while i < out_brackets.len() - 2 && !result && in_brackets.len() > 0
    {
        let mut s: Vec<char> = Vec::new();
        s.push(out_brackets.chars().nth(i).unwrap());
        s.push(out_brackets.chars().nth(i+1).unwrap());
        s.push(out_brackets.chars().nth(i+2).unwrap());
        result = is_aba(&s, &in_candidates);
        i += 1;
    }
    result
}

fn is_aba(aba: &Vec<char>, words: &Vec<String>) -> bool
{
    let mut result = false;
    let mut rev_str: String = String::new();
    let mut chars: HashMap<char, char> = HashMap::new();
    chars.insert(aba[0], aba[1]);
    chars.insert(aba[1], aba[0]);
    chars.insert(aba[2], aba[1]);

    /* reverse string */
    if chars.len() == 2
    {
        for i in 0..3
        {
            rev_str.push_str(&chars.get(&aba[i]).unwrap().to_string());
        }
        for word in words
        {
            if rev_str == word.to_string() { result = true; break;}
        }
    }
    result
}
fn valid_abba(seq: &String) -> bool
{
    let mut found = false;
    let mut i = 0;
    while i < seq.len() - 3
    {
        let ch1 = seq.chars().nth(i).unwrap();
        let ch2 = seq.chars().nth(i+1).unwrap();
        let ch3 = seq.chars().nth(i+2).unwrap();
        let ch4 = seq.chars().nth(i+3).unwrap();
        /* abba */
        if ch1 == ch4 && ch3 == ch2 && ch1 != ch2 { found = true; }
        i += 1;
    }
    found
}

fn get_lines<P>(filename: P) -> Vec<String>
where P: AsRef<Path>,
      {
          let file = File::open(filename).expect("no such file");
          let buf = BufReader::new(file);
          buf.lines().map(|l| l.expect("Could not parse line")).collect()
      }

#[test]
fn tests()
{
    let path = Path::new("test_input.txt");
    let lines = get_lines(path);
    let test1 = part_a(&lines);
    assert!(test1 == 2);
    let mut lines2: Vec<String>= Vec::new();
    lines2.push("aba[bab]xyz".to_string());
    lines2.push("xyx[xyx]xyx".to_string());
    lines2.push("aaa[kek]eke".to_string());
    lines2.push("zazbz[bzb]cdb".to_string());
    let test2 = part_b(&lines2);
    assert!(test2 == 3);
}
