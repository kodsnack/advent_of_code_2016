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

fn main()
{
    let path = Path::new("input.txt");
    let lines = get_lines_from_file(path);
    for line in lines 
    {
        print!("{} \n", line);
    }

}

fn get_lines_from_file<P>(filename: P) -> Vec<String>
    where P: AsRef<Path>,
{
    let file = File::open(filename).expect("no such file");
    let buf = BufReader::new(file);
    buf.lines().map(|l| l.expect("Could not parse line")).collect()
}
