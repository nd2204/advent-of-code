use std::fs;

#[allow(unused)]
fn main() {
    let file_path = "day1.txt";
    let content: Vec<String> = read_line(file_path);

    let result = process(&content);
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

    for (idx, c) in s.chars().enumerate() {
        if c.is_digit(10) {
            result.push(c);
            s.remove(idx);
            break;
        }
    }

    for c in s.chars().rev() {
        if c.is_digit(10) {
            result.push(c);
            break;
        }
    }

    println!("{result}\t<-\t{input}");
    let result: u32 = result.trim().parse().unwrap();
    result
}

fn word_to_num(input: &str) -> String {
    let mut s = input.to_string();
    let units = vec![
        "zero", "one", "two",   "three", "four",
        "five", "six", "seven", "eight", "nine"
    ];

    for (idx, &unit) in units.iter().enumerate() {
        s = s.replace(unit, &idx.to_string());
    }
    s
}

fn read_line(filename: &str) -> Vec<String> {
    fs::read_to_string(filename)
        .unwrap()
        .lines()
        .map(String::from)
        .collect()
}
