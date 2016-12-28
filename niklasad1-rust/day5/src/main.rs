/*
 *  @email          niklasadolfsson1@gmail.com
 *  @desc           AoC #5
 *  @date           2016-12-28
 */

extern crate crypto;

use crypto::md5::Md5;
use crypto::digest::Digest;

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
    for i in 0..8
    {
        while !found
        {
            let new_str: String = input.to_string() + &count.to_string();
            hasher.input(new_str.as_bytes());
            let mut buf = [0; 16];
            hasher.result(&mut buf);
            hasher.reset();
            let ch = get_sixth_hex_char(&buf[0 .. 3]);
            if ch != -1 { found=true; pwd.push_str(&format!("{:x}", ch)); }
            count += 1;
        }
        found = false;
    }
    pwd
}


fn part_b(input: &str) -> String
{
    "todo".to_string()
}


/* hex notation 0xAB i.e each characther 4 bits */
fn get_sixth_hex_char(buf: &[u8]) -> isize
{
    let ret =
        if buf[0] as i32 + buf[1] as i32 + (buf[2] >> 4) as i32 == 0
        {
            /* MSB will always be zero i.e. 0x0X */
            buf[2] as isize
        }
        else {-1};
    ret
}




#[test]
fn tests()
{
    let x = part_a("abc");
    assert!(x == "18f47a30");
}
