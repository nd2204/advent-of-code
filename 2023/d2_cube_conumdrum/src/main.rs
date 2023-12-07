use std::fs::read_to_string;
use regex::Regex;

#[allow(unused)]
fn main() {
    let content: Vec<String> = read_to_string("day2.txt")
        .unwrap().lines().map(String::from).collect();

    // let mut total = 0;
    // for lines in content {


    // }
    is_possible(&content[1]);
}

fn is_possible(input: &str) -> bool {
    let mut result = vec![];
    let greens = Regex::new(r"(\d*) green").unwrap();
    let reds = Regex::new(r"(\d*) red").unwrap();
    let blues = Regex::new(r"(\d*) blue").unwrap();

    greens.captures_iter(input).map(|caps| {

    };
    println!("{:?}", result);

    false
}
