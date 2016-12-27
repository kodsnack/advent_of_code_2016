/*
 *  @author         Niklas Adolfsson
 *  @email          niklasadolfsson1@gmail.com
 *  @desc           AoC #4
 *  @date           2016-12-27
 */

extern crate regex;

use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use std::path::Path;
use std::ascii::AsciiExt;
use std::collections::HashMap;
use std::collections::hash_map::Entry;
use regex::Regex;
use std::iter::FromIterator;

fn main()
{
    let path = Path::new("input.txt");
    // let path = Path::new("input_test.txt");
    let lines = get_lines_from_file(path);
    let mut counter = 0;
    for line in lines
    {

        let mut seq: usize = 0;
        let mut name: &str = "";
        let mut crc: &str = "";
        let mut letter_count = vec![0; 26];

        let re = Regex::new(r"(?P<name>[[:alpha:]-]+)(?P<seq>[\d]{3})\[(?P<crc>[[:alpha:]]+)\]").unwrap();

        for cap in re.captures_iter(&line)
        {
            name = cap.name("name").unwrap_or("");
            crc = cap.name("crc").unwrap_or("");
            seq = cap.name("seq").unwrap_or("").parse().unwrap();
        }
        print!("{} {} {}\n", name, seq, crc);
        for c in name.chars()
        {
            let ch = c.to_ascii_lowercase();

            match ch as usize
            {
                /* a-z increase count */
                97 ... 122 => letter_count[ch as usize -97] += 1,
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
    print!("partA: {} \n", counter);
}

fn get_lines_from_file<P>(filename: P) -> Vec<String>
where P: AsRef<Path>,
      {
          let file = File::open(filename).expect("no such file");
          let buf = BufReader::new(file);
          buf.lines().map(|l| l.expect("Could not parse line")).collect()
      }

fn create_empty_hash_table() -> HashMap<char, u8>
{
    let mut letters_count = HashMap::new();
    for i in 0..26
    {
        let c: u8 = i + 97;
        letters_count.insert(c as char, 0);
    }
    letters_count
}


/*
 * This function is not elegant  but it's pretty straight-forward
 *
 * 1. add the top-5 letters to a hash table where higher rank's are stored as keys, i.e. 0 highest, 1
 *    second highest .... and so on but several letters can have the same rank.
 * 2. determine whether the crc is valid by popping elements from the hashmap
 *
 */
fn valid_crc(crc: &str, letters: &mut Vec<isize>) -> bool
{
    let mut rank: HashMap<isize, Vec<char>> = HashMap::new();
    for i in 0..5
    {
        /* find the first biggest */
        let mut biggest = (0, 0);
        for j in 0..letters.len()
        {
            biggest = match biggest
            {
                (_, v) if letters[j] > v => (j, letters[j]),
                (_, _) => biggest,
            }
        }

        match biggest
        {
            (0, 0) => break,
            (_, _) => print!(""),
        };

        letters[biggest.0] = -1;
        rank.insert(i, vec![usize_to_char(biggest.0)]);

        /* find elements with equal frequency */
        for j in 0..letters.len()
        {
            if biggest.1 == letters[j] && biggest.0 != j
            {
                match rank.entry(i as isize)
                {
                    Entry::Occupied(mut e) => e.get_mut().push(usize_to_char(j)),
                    _ => panic!("error should not happen"),
                }
                letters[j] = -1;
            }
        }
    }

    print!("{:?}\n", rank);

    let mut index = 0;
    let mut crc_count = 0;
    while !rank.is_empty() && crc_count < 4
    {
        let s = match rank.remove(&index)
        {
            Some(value) => String::from_iter(value),
            None => panic!("\n"),
        };
        
        let mut max = s.len(); 
        while crc_count < 4 && max > 0
        {
            for c in s.chars()
            {
                if c == crc.chars().nth(crc_count).unwrap()
                {
                    crc_count += 1;
                    break;
                }
            }
            max -= 1;
        }
        index += 1;
    }
    print!("crc_count {} crc {}\n", crc_count, crc);
    let ret = if crc_count == 4 {true} else {false};
    ret
}

fn usize_to_char(v: usize) -> char
{
    let dummy = (v+97) as u8;
    let ch = dummy as char;
    ch
}
