import 'dart:convert';
import 'package:main/solvable.dart';

class Day1 implements Solvable {

  @override
  void solve(Stream<String> input) {
    final int openParen = utf8.encode('(')[0];

    input.forEach((elem) {
      int position = 1;
      int level = 0;
      int? firstPosition;

      for (final c in elem.runes) {
      level += (c == openParen) ? 1 : -1;
      if (firstPosition == null && level == -1) firstPosition = position;
      position++;
    }

      print(level);
      print(firstPosition);
    });
  }

}
