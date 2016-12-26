/*
 *  @author         Niklas Adolfsson
 *  @email          niklasadolfsson1@gmail.com
 *  @desc           AoC #3.
 *  @date           2016-12-26
 */

use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use std::path::Path;

fn main()
{
    let path = Path::new("input.txt");
    let numbers = get_words(path);
    part_a(&numbers);
    part_b(&numbers);
}


fn part_a(lines: &Vec<u32>)
{
    let mut triangel_count: u32 = 0;
    let mut i = 0;
    while i < lines.len()-2  
    {
        let triangel = (lines[i], lines[i+1], lines[i+2]);
        triangel_count = valid_triangel(triangel_count, triangel);
        i = i + 3;
    }
    print!("partA the number of valid triangels are: {}\n", triangel_count);
}


fn part_b(lines: &Vec<u32>)
{
    let mut triangel_count: u32 = 0;
    let mut i = 0; 
    
    while i < lines.len()-8
    {
        let triangel1 = (lines[i], lines[i+3], lines[i+6]);
        triangel_count = valid_triangel(triangel_count, triangel1);
        let triangel2 = (lines[i+1], lines[i+4], lines[i+7]);
        triangel_count = valid_triangel(triangel_count, triangel2);
        let triangel3 = (lines[i+2], lines[i+5], lines[i+8]); 
        triangel_count = valid_triangel(triangel_count, triangel3);
        i = i+9;
    }
    print!("partB the number of valid triangels are: {}\n", triangel_count);

}


fn get_words<P>(filename: P) -> Vec<u32>
where P: AsRef<Path>,
      {
          let mut vec: Vec<u32> = Vec::new();
          let reader = BufReader::new(File::open(filename).expect("no such file"));
          for line in reader.lines()
          {
              for word in line.unwrap().split_whitespace() {
                  vec.push(word.parse::<u32>().unwrap());
              }
          }
          vec
      }


fn valid_triangel(c: u32, triangel: (u32, u32, u32)) -> u32
{
    let mut count: u32 = c;
    count = match triangel
    {
        (x, y, z) if x >= y+z => count,
        (x, y, z) if y >= x+z => count,
        (x, y, z) if z >= x+y => count,
        (_, _, _) => count+1,
    };
    count
}
