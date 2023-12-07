use std::fs;

#[allow(unused)]
fn main() {
    let file_path = "day1.txt";
    let content: Vec<String> = read_line(file_path);
    let result = process(&content);

    // println!();
    assert_eq!(process_line("oneight"), 18);
    assert_eq!(process_line("two1nine"), 29);
    assert_eq!(process_line("eightwothree"), 83);
    assert_eq!(process_line("abcone2threexyz"), 13);
    assert_eq!(process_line("xtwone3four"), 24);
    assert_eq!(process_line("4nineeightseven2"), 42);
    assert_eq!(process_line("zoneight234"), 14);
    assert_eq!(process_line("7pqrstsixteen"), 76);
    assert_eq!(process_line("oneightoneightwone"), 11);
    // assert_eq!(word_to_num("oneightwone"), "1821");
    println!("the result is: {result}");
}

#[allow(unused)]
fn process(input: &Vec<String>) -> u32 {
    let mut total: u32 = 0;

    for lines in input {
        total += process_line(&lines)
    }

    total
}

#[allow(unused)]
fn process_line(input: &str) -> u32 {
    let mut result: String = String::new();
    let mut s: String = word_to_num(input);

    for c in s.chars() {
        if c.is_digit(10) {
            result.push(c);
            break;
        }
    };

    for c in s.chars().rev() {
        if c.is_digit(10) {
            result.push(c);
            break;
        }
    }

    // println!("{result} <- {s} <- {input}");
    let result: u32 = result.trim().parse().unwrap();
    result
}

#[allow(unused_mut)]
fn word_to_num(input: &str) -> String {
    let mut s = input.to_string();
    let mut new = String::new();
    let units = vec![
        "zero", "one", "two",   "three", "four",
        "five", "six", "seven", "eight", "nine"
    ];

    let mut idx = 0;
    let length = s.len();

    while idx < length {
        let mut found = false;
        for (n, unit) in units.iter().enumerate() {
            if (&s[idx..]).starts_with(unit) {
                new.push_str(&n.to_string());
                idx += unit.len() - 1;
                found = true;
                break;
            }
        }
        if !found {
            new.push_str(&s[idx..idx+1]);
            idx += 1;
        }
    }

    return new;
}

fn read_line(filename: &str) -> Vec<String> {
    fs::read_to_string(filename)
        .unwrap()
        .lines()
        .map(String::from)
        .collect()
}
