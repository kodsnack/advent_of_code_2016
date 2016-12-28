/*
 *  @desc           AoC #5
 *  @author         Niklas Adolfsson
 *  @email          niklasadolfsson1@gmail.com
 *  @date           2016-12-28
 */

extern crate crypto;

use crypto::md5::Md5;
use crypto::digest::Digest;
use std::iter::FromIterator;


fn main()
{
    let input = "wtnhxymk";
    print!("partA {} \n", part_a(&input));
    print!("partB {} \n", part_b(&input));

}

fn part_a(input: &str) -> String
{
    let mut pwd: String = String::new();
    let mut found = false;
    let mut count = 0;
    let mut hasher = Md5::new();
    for _ in 0..8
    {
        while !found
        {
            let new_str: String = input.to_string() + &count.to_string();
            hasher.input(new_str.as_bytes());
            let mut buf = [0; 16];
            hasher.result(&mut buf);
            hasher.reset();
            match get_sixth_char(&buf[0 .. 3])
            {
                e @ 0...16 => { found=true; pwd.push_str(&format!("{:x}", e)) }
                _ => found = false,
            };
            count += 1;
        }
        found = false;
    }
    pwd
}


fn part_b(input: &str) -> String
{
    let mut pwd = vec!['_'; 8];
    let mut found = false;
    let mut count = 0;
    let mut hasher = Md5::new();
    for _ in 0..8
    {
        while !found
        {
            let new_str: String = input.to_string() + &count.to_string();
            hasher.input(new_str.as_bytes());
            let mut buf = [0; 16];
            hasher.result(&mut buf);
            hasher.reset();
            match  get_sixth_seventh_char(&buf[0 .. 4])
            {
                (pos, value) if pos < 8 && value < 16  && pwd[pos as usize] == '_' => 
                { pwd[pos as usize] = format!("{:x}", value).chars().nth(0).unwrap(); found = true }
                (_, _) => found=false,
            };
            count += 1;
        }
        found = false;
    }
    let s = String::from_iter(pwd);
    s
}


/* hex notation 0xAB i.e each characther 4 bits */
fn get_sixth_char(buf: &[u8]) -> u8
{
    let ret =
        if buf[0] as i32 + buf[1] as i32 + (buf[2] >> 4) as i32 == 0
        {
            /* MSB will always be zero i.e. 0x0X */
            buf[2]
        }
        else {255};
    ret
}

fn get_sixth_seventh_char(buf: &[u8]) -> (u8,u8)
{
    let ret =
        if buf[0] as i32 + buf[1] as i32 + (buf[2] >> 4) as i32 == 0
        {
            (buf[2], buf[3] >> 4)
        }
        else { (255,255) };
    ret
}

#[test]
fn tests()
{
    let x = part_a("abc");
    assert!(x == "18f47a30");
    let y = part_b("abc");
    assert!(y == "05ace8e3");
}
