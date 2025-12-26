import 'dart:convert';
import 'dart:io';

import 'package:main/day5.dart';
import 'package:main/solvable.dart';

void main(List<String> arguments) {
  final Solvable solver = Day5() as Solvable;
  final String fileName = solver.runtimeType.toString().toLowerCase();

  try {
    solver.solve(File('$fileName.txt').openRead().transform(utf8.decoder));
  } catch (e) {
    print(e);
  }
}
