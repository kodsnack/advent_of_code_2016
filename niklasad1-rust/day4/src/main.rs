/*
 *  @author         Niklas Adolfsson
 *  @email          niklasadolfsson1@gmail.com
 *  @desc           AoC #4
 *  @date           2016-12-26
 */

use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use std::path::Path;
use std::ascii::AsciiExt;
use std::collections::HashMap;
extern crate regex;
use regex::Regex;



fn main()
{
    // let path = Path::new("input.txt");
    let path = Path::new("input_test.txt");
    let lines = get_lines_from_file(path);
    let mut counter = 0;
    for line in lines
    {
        let mut letters_count = create_empty_hash_table();
        let mut num: usize = 0;
        let mut name: &str = "";
        let mut crc: &str = "";

        // let re = Regex::new(r"(?P<name>[[\w-]]+)\[(?P<crc>[[:alpha:]]+)").unwrap();
        let re = Regex::new(r"(?P<name>[[:alpha:]-]+)(?P<seq>[\d]{3})\[(?P<crc>[[:alpha:]]+)\]").unwrap();

        for cap in re.captures_iter(&line)
        {
            // print!("{:?} \n", cap.name("name"));
            // print!("{:?} \n", cap.name("seq"));
            // print!("{:?} \n", cap.name("crc"))
            name = cap.name("name").unwrap_or("");
            crc = cap.name("crc").unwrap_or("");
            num = cap.name("seq").unwrap_or("").parse().unwrap();
        }

        for c in name.chars()
        {
            let ch = c.to_ascii_lowercase();

            match ch as usize
            {
                /* a-z increase count */
                97 ... 122 =>
                    match letters_count.get_mut(&ch)
                    {
                        Some(count) => *count += 1,
                        None => panic!("letter not in letter_table"),
                    },
                    /* do nothing '-' */
                45 => print!("-\n"),
                _ => print!("etc\n"),
            };
        }
        // print!("hash table {:?} \n", letters_count);
        // print!("crc {} \n", crc);
        // print!("num {} \n", num);
        counter = match valid_crc(crc, letters_count)
        {
            true => counter+num,
            _ => counter,
        };
    }

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

fn valid_crc(crc: &str, mut letters: HashMap<char,u8>) -> bool
{
    let candidates: Vec<&str> = Vec::new();
    for i in 0..5
    {
        /* key, value */
        let mut smallest = (&'0', 0);
        for (key, &value) in letters.iter()
        {
            smallest = match smallest 
            {
                (k, v) if value > v => (key, value),
                (_, _) => smallest,
            }
        }
        let item = letters.remove(&smallest.0);
        print!("biggest {} {:?}\n", i, item); 
    }
    true
}








