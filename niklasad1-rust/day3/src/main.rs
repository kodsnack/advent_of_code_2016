/*
 *  @author         Niklas Adolfsson
 *  @email          niklasadolfsson1@gmail.com
 *  @desc           AoC #3.
 *  @date           2016-12-25
 */

#![feature(slice_patterns)]
extern crate regex;
use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use std::path::Path;
use regex::Regex;

fn main()
{
    let path = Path::new("input.txt");
    let lines = get_lines_from_file(path);
    part_a(&lines);
    part_b(&lines);
}


fn part_a(lines: &Vec<String>)
{
    let mut triangel_count: u32 = 0;
    for line in lines
    {
        let mut nums = Vec::new();
        let re = Regex::new(r"(\d+)").unwrap();
        for cap in re.captures_iter(&line) {
            nums.push(cap.at(1).unwrap().parse::<i32>().unwrap());
        }

        triangel_count = match &nums[..]
        {
            &[x, y, z] if x >= y+z => triangel_count,
            &[x, y, z] if y >= x+z => triangel_count,
            &[x, y, z] if z >= x+y => triangel_count,
            &[_, _, _] => triangel_count+1,
            _ => panic!("pattern matching error"),
        };
    }
    print!("the number of triangels are: {}\n", triangel_count);
}


fn part_b(lines: &Vec<String>)
{
    let mut triangel_count: u32 = 0;
    let mut dummy: Vec<i32> = Vec::new();
    let mut vec: Vec<Vec<i32>> = vec![ dummy.clone(), dummy.clone(), dummy.clone()];

    for line in lines
    {

        let re = Regex::new(r"(\d+)").unwrap();
        let mut i = 0;
        for cap in re.captures_iter(&line) {
            vec[i].push(cap.at(1).unwrap().parse::<i32>().unwrap());
            i = i+1;
        }
    }

    vec[0].sort();
    vec[1].sort();
    vec[2].sort();

    while vec[0].len() >= 3 {
        let item = vec[0].get(0);
        print!("{:?} \n", item);
        break;
    }
    
    
    print!("the number of triangels are: <TODO> {}\n", triangel_count);

}


fn get_lines_from_file<P>(filename: P) -> Vec<String>
where P: AsRef<Path>,
      {
          let file = File::open(filename).expect("no such file");
          let buf = BufReader::new(file);
          buf.lines().map(|l| l.expect("Could not parse line")).collect()
      }
