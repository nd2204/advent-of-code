use std::collections::HashMap;
use std::fs;

#[allow(unused)]
fn main() {
    let file_path = "day1.txt";
    let content: Vec<String> = read_line(file_path);

    let result = process(&content);
    assert_eq!(word_to_num("eightwo91"), "8wo91");
    assert_eq!(word_to_num("oneight91"), "1ight91");
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

    loop {
        let mut counter: HashMap<&str, usize> = HashMap::new();
        for unit in units.iter() {
            counter.insert(unit, match s.find(unit) {
                Some(n) => n,
                None => continue
            });
        }

        if counter.is_empty() {
            break;
        }

        println!("map: {:?}", counter);
        let mut sorted_counter: Vec<&str, usize> = counter.keys().collect();
        sorted_counter.sort_by(|a, b| a.1.cmp(b.1));
        println!("sorted: {:?}", sorted_counter);

        for &unit in sorted_counter {
            let idx = match units.iter().position(|&x| x == unit) {
                Some(n) => n,
                None => {
                    println!("Error no units match");
                    break
                }
            };
            s = s.replacen(unit, &idx.to_string(), 1);
        }
    }

    return s;
}

fn read_line(filename: &str) -> Vec<String> {
    fs::read_to_string(filename)
        .unwrap()
        .lines()
        .map(String::from)
        .collect()
}
