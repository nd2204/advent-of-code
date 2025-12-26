import 'dart:convert';

import 'package:main/solvable.dart';

const up = 94;
const down = 118;
const left = 60;
const right = 62;

class Position {
  late int _x;
  late int _y;

  Position(int x, int y) : _x = x, _y = y;

  (int, int) move(int dir) {
    switch (dir) {
      case up:
        _y++;
      case down:
        _y--;
      case left:
        _x--;
      case right:
        _x++;
      default:
        throw ArgumentError(
          "Unknown direction codepoint: "
          "${utf8.decode([dir])} ($dir)",
        );
    }
    return (_x, _y);
  }
}

class Day3 implements Solvable {
  @override
  void solve(Stream<String> input) async {
    Position santa = Position(0, 0);
    Position robo = Position(0, 0);

    Set<(int, int)> visited = {(0, 0)};

    var it = (await input.first).runes.iterator;
    while (it.moveNext()) {
      visited.add(santa.move(it.current));
      if (it.moveNext()) visited.add(robo.move(it.current));
    }

    print(visited.length);
  }
}
