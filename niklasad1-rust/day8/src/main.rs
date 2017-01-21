/*
 *  @author         Niklas Adolfsson
 *  @email          niklasadolfsson1@gmail.com
 *  @desc           AoC #8
 *  @date           2017-01-21
 */

extern crate regex;

use regex::Regex;
use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
use std::path::Path;

fn main()
{
    let path = Path::new("input.txt");
    let lines = get_lines(path);
    part_a_b(&lines);
}

fn part_a_b(lines: &Vec<String>)
{
    let mut pixels: [[char; 50]; 6] = [['.'; 50]; 6];
    for line in lines
    {
        let mut parsed: Vec<usize> = Vec::new();
        // print!("{}\n", line);
        let re = Regex::new(r"\d+").unwrap();
        for caps in re.captures_iter(&line) {
            parsed.push(caps.at(0).unwrap().parse::<usize>().unwrap());
        }

        if line.contains("rect")
        {
            // print!("create rect {:?}\n", parsed);
            create_rect(parsed[0], parsed[1], &mut pixels);
            // print_keypad(&mut pixels);
        }
        else if line.contains("rotate column")
        {
            // print!("rotate column {:?}\n", parsed);
            rotate_column(parsed[0], parsed[1], &mut pixels);
            // print_keypad(&mut pixels);
        }
        else
        {
            // print!("rotate row{:?}\n", parsed);
            rotate_row(parsed[0], parsed[1], &mut pixels);
            // print_keypad(&mut pixels);
        };

    }
    print!("partA: {}\n", count_pixels(&mut pixels));
    print!("partB: \n");
    print_keypad(&mut pixels);

}

fn count_pixels(pixels: &mut[[char; 50]; 6]) -> usize
{
    let mut count: usize = 0;
    for i in 0..6
    {
        for j in 0..50
        {
            if pixels[i][j] == '#' { count += 1; }
        }
    }
    count
}

fn create_rect(x: usize, y: usize, pixels: &mut[[char; 50]; 6])
{
    for i in 0..y
    {
        for j in 0..x
        {
            pixels[i][j] = '#';
        }
    }
}

fn rotate_row(row:usize, step: usize, pixels: &mut[[char; 50]; 6])
{
    for _ in 0..step
    {
        let mut i: isize = 48;
        let last = pixels[row][i as usize+1];
        while i > -1
        {
            pixels[row][i as usize+1] = pixels[row][i as usize];
            i -= 1;
        }
        pixels[row][0] = last;
    }
}

fn rotate_column(col: usize, step: usize, pixels: &mut[[char; 50]; 6])
{
    for _ in 0..step
    {
        let mut i: isize = 4;
        let last = pixels[i as usize+1][col];
        while i > -1
        {
            pixels[i as usize+1][col] = pixels[i as usize][col];
            i -= 1;
        }
        pixels[0][col] = last;

    }
}

fn print_keypad(pixels: &mut[[char; 50]; 6])
{
    for i in 0..6
    {
        for j in 0..50
        {
            print!("{}", pixels[i][j]);
        }
        print!("\n");
    }
}

fn get_lines<P>(filename: P) -> Vec<String>
where P: AsRef<Path>,
      {
          let file = File::open(filename).expect("no such file");
          let buf = BufReader::new(file);
          buf.lines().map(|l| l.expect("Could not parse line")).collect()
      }
