#!/usr/bin/env python

import urllib.request
import http.cookiejar
import argparse
from pathlib import Path

BASE_URL = 'https://adventofcode.com'
COOKIE_FILE = Path.home() / '.aocf_cookie'

parser = argparse.ArgumentParser(
    prog='aoc-fetch',
    description='Get the puzzle input for the provided day and year from the advent of code website',
)

parser.add_argument('year')
parser.add_argument('day')
parser.add_argument('--cookies')
parser.add_argument('-f','--file', help="the output file of the fetched puzzle's input")

args = parser.parse_args()
cookies_str = args.cookies

if not cookies_str:
    try:
        with open(COOKIE_FILE, 'r') as f:
            cookies_str = f.read().strip()
    except FileNotFoundError:
        print(f"{COOKIE_FILE} not found")
        print("Paste your cookies string separated by semicolon to create")
        cookies_str = input("Cookies (empty to cancel):")
        if cookies_str:
            with open(COOKIE_FILE, 'w') as f:
                f.write(cookies_str)
                pass
        exit(-1)

input_url = f'{BASE_URL}/{args.year}/day/{args.day}/input'
req = urllib.request.Request(input_url, headers={
    'User-Agent': 'Mozilla/5.0',
    'Cookie': cookies_str
})

try:
    with urllib.request.urlopen(req) as response:
        data_bytes = response.read()
        data_string = data_bytes.decode('utf-8')
        outfile = args.file
        if not outfile:
            outfile = f'./day{args.day}.txt'
        with open(outfile, 'w') as f:
            print(data_string);
            print(f"Written {f.write(data_string)} byte(s) to {Path(outfile).resolve()}")
except Exception as e:
    print(f"An error occurred: {e}")
