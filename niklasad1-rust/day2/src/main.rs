/*
 *  @author         Niklas Adolfsson
 *  @email          niklasadolfsson1@gmail.com
 *  @desc           AoC #2.
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
    part_a(&lines, 4 as usize);
    part_b(&lines, 4 as isize);
}

fn part_a(lines: &Vec<String>, x: usize)
{
    let digit = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
    let mut passcode = String::new();
    let mut pos:usize = x;

    for line in lines
    {
        // print!("{:?} \n", line);
        for c in line.chars()
        {
            // print!("pos {} \t char {} \n", pos, c);
            pos = match c
            {
                'U' if pos > 2 => pos-3, 
                'D' if pos < 6 => pos+3,
                'L' if pos % 3 != 0 => pos-1,
                'R' if pos != 2 &&  pos != 5 && pos != 8 => pos+1,
                 _ => pos,
            };
        }
        
        passcode.push(digit[pos]);
    }
    
    print!("the passcode for partA is {}\n", passcode);
}


fn part_b(lines: &Vec<String>, x: isize)
{

    let digit = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D'];
    let moves = set_moves();
    let mut pos: isize = x as isize; 
    let mut passcode = String::new();

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
    print!("the passcode for partB is {}\n", passcode);
}


fn get_lines_from_file<P>(filename: P) -> Vec<String>
    where P: AsRef<Path>,
{
    let file = File::open(filename).expect("no such file");
    let buf = BufReader::new(file);
    buf.lines().map(|l| l.expect("Could not parse line")).collect()
}

fn set_moves() -> HashMap<isize, (isize, isize, isize, isize)>
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
