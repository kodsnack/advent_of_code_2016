/*
 *  @author         Niklas Adolfsson
 *  @email          niklasadolfsson1@gmail.com
 *  @desc           AoC #2 PartB
 *  @date           2016-12-25
 */

use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use std::path::Path;
use std::collections::HashMap;

fn main()
{
    let path = Path::new("input.txt");
    /* array of strs */
    let lines = get_lines_from_file(path);
    let mut passcode = String::new();
    let digit = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D'];
    let moves = init_moves();
    let mut pos: isize = 4;
    
    for line in lines
    {
        for c in line.chars()
        {
            pos = match moves.get(&pos)
            {
                Some(value) => 
                    match c 
                    {
                        'U' if value.0 != 0 => pos + value.0,
                        'D' if value.1 != 0 => pos + value.1,
                        'L' if value.2 != 0 => pos + value.2,
                        'R' if value.3 != 0 => pos + value.3,
                         _ => pos,
                    },
                _ => panic!("invalid position"),
            };
        }
        passcode.push(digit[pos as usize]);
    }
    print!("the passcode is {}\n", passcode);
}


fn get_lines_from_file<P>(filename: P) -> Vec<String>
where P: AsRef<Path>,
      {
          let file = File::open(filename).expect("no such file");
          let buf = BufReader::new(file);
          buf.lines().map(|l| l.expect("Could not parse line")).collect()
      }

fn init_moves() -> HashMap<isize, (isize, isize, isize, isize)>
{
    let mut dir = HashMap::new();
    /* (up, down, left, right) */
    dir.insert(0, (0, 2, 0, 0));            /* 1 */ 
    dir.insert(1, (0, 4, 0, 1));            /* 2 */    
    dir.insert(2, (-2, 4, -1, 1));           /* 3 */
    dir.insert(3, (0, 4, -1, 0));            /* 4 */
    dir.insert(4, (0, 0, 0, 1));            /* 5 */
    dir.insert(5, (-4, 4, -1, 1));            /* 6 */
    dir.insert(6, (-4, 4, -1, 1));            /* 7 */
    dir.insert(7, (-4, 4, -1, 1));            /* 8 */
    dir.insert(8, (0, 0, -1, 0));            /* 9 */
    dir.insert(9, (-4, 0, 0, 1));            /* A */
    dir.insert(10, (-4, 2, -1, 1));           /* B */
    dir.insert(11, (-4, 0, -1, 0));           /* C */
    dir.insert(12, (-2, 0, 0, 0));           /* D */
    dir
}
