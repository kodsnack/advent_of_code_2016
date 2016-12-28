/*
 *  @author         Niklas Adolfsson
 *  @email          niklasadolfsson1@gmail.com
 *  @desc           AoC #4
 *  @date           2016-12-27
 */

extern crate regex;

use std::char;
use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use std::path::Path;
use std::ascii::AsciiExt;
use regex::Regex;
use std::iter::FromIterator;
use std::collections::VecDeque;

fn main()
{
    let path = Path::new("input.txt");
    // let path = Path::new("input_test.txt");
    let lines = get_lines_from_file(path);
    print!("partA {} \n", part_a(&lines));
    print!("partB {} \n",part_b(&lines, "northpole"));
}

fn part_a(lines: &Vec<String>) -> u32
{
    let mut counter: u32 = 0;
    for line in lines
    {
        let mut seq: u32 = 0;
        let mut name: &str = "";
        let mut crc: &str = "";
        let mut letter_count = vec![0; 26];

        /* group chars, as "x-y-z-" 123 [abcde] */
        let re = Regex::new(r"(?P<name>[[:alpha:]-]+)(?P<seq>[\d]{3})\[(?P<crc>[[:alpha:]]+)\]").unwrap();

        for cap in re.captures_iter(line)
        {
            name = cap.name("name").unwrap_or("");
            crc = cap.name("crc").unwrap_or("");
            seq = cap.name("seq").unwrap_or("").parse().unwrap();
        }
        for c in name.chars()
        {
            let ch = c.to_ascii_lowercase() as usize;
            match ch
            {
                /* a-z increase count */
                97 ... 122 => letter_count[ch-97] += 1,
                /* - */
                45 => print!(""),
                _ => panic!("in-expected char"),
            };
        }
        counter = match valid_crc(crc, &mut letter_count)
        {
            true => counter + seq,
            _ => counter,
        };
    }
    counter
}


fn part_b(lines: &Vec<String>, exp_str: &str) -> u32
{
    let mut counter = 0;
    let mut seq: u32 = 0;
    let mut name: &str = "";
    for line in lines
    {
        let mut s = String::new();
        /* group chars, as "x-y-z-" 123 [abcde] */
        let re = Regex::new(r"(?P<name>[[:alpha:]-]+)(?P<seq>[\d]{3})\[(?P<crc>[[:alpha:]]+)\]").unwrap();

        for cap in re.captures_iter(line)
        {
            name = cap.name("name").unwrap_or("");
            seq = cap.name("seq").unwrap_or("").parse().unwrap();
        }

        // print!("name {} \n", name);
        for c in name.chars()
        {
            let ch = c.to_ascii_lowercase() as u32;

            match ch
            {
                /* a-z increase count */
                97 ... 122 => s.push(shift_cipher(ch, seq)),
                /* - */
                45 => print!(""),
                _ => panic!("in-expected char"),
            };
        }
        
        if s.contains(exp_str) {counter = counter+seq}
    }
    counter
}


fn shift_cipher(letter: u32, shift: u32) -> char
{
    let num = ((letter - 97) + shift) % 26;
    let alpha = num + 97; 
    let ch  = match char::from_u32(alpha)
    {
        Some(v) => v,
        _ => panic!("decryption failed"),
    };
    ch
}

fn get_lines_from_file<P>(filename: P) -> Vec<String>
where P: AsRef<Path>,
      {
          let file = File::open(filename).expect("no such file");
          let buf = BufReader::new(file);
          buf.lines().map(|l| l.expect("Could not parse line")).collect()
      }

/*
 * This function is not elegant  but it's pretty straight-forward
 *
 * 1. add the top-5 letters to a fifi queue  where higher rank's are stored as keys, i.e. 0 highest, 1
 *    second highest .... and so on but several letters can have the same rank.
 * 2. determine whether the crc is valid by popping elements from the queue
 *
 */
fn valid_crc(crc: &str, letters: &mut Vec<isize>) -> bool
{

    let mut queue = add_in_order(letters);
    let mut crc_count = 0;
    let mut exp = 0;
    let mut invalid = false;
    while !queue.is_empty() && !invalid
    {
        let s = match queue.pop_front()
        {
            Some(value) => String::from_iter(value),
            None => panic!("not possible"),
        };
        let len = s.len();
        exp = if exp + len <= 4 {exp+len} else {4};
        if exp > crc_count
        {
            for _ in 0..exp-crc_count
            {
                for c in s.chars()
                {
                    if c == crc.chars().nth(crc_count).unwrap() { crc_count += 1; break;}
                }
            }
        }
        if exp != crc_count {invalid=true;}
    }
    let ret = if crc_count == 4 {true} else {false};
    ret
}

fn usize_to_char(v: usize) -> char
{
    let dummy = (v+97) as u8;
    let ch = dummy as char;
    ch
}

fn add_in_order(letters: &mut Vec<isize>) -> VecDeque<Vec<char>>
{
    let mut queue: VecDeque<Vec<char>> = VecDeque::new();
    for _ in 0..5
    {
        /* find the first biggest */
        let mut vec = Vec::new();
        let mut biggest = (0, 0);
        for j in 0..letters.len()
        {
            biggest = match biggest
            {
                (_, v) if letters[j] > v => (j, letters[j]),
                (_, _) => biggest,
            }
        }
        if biggest == (0,0) {break;}

        letters[biggest.0] = -1;
        vec.push(usize_to_char(biggest.0));

        /* find elements with equal frequency */
        for j in 0..letters.len()
        {
            if biggest.1 == letters[j] && biggest.0 != j
            {
                vec.push(usize_to_char(j));
                letters[j] = -1;
            }
        }
        queue.push_back(vec);
    }
    queue
}

#[test]
fn tests()
{
    let mut test: Vec<String> = Vec::new(); 
    test.push(String::from("qzmt-zixmtkozy-ivhz-343[abcde]"));
    let x= part_b(&test, "veryencryptedname");
    assert!(x == 343);
}
