import 'dart:convert';

import 'package:main/bitset.dart';
import 'package:main/solvable.dart';

enum OPCode { turnOn, turnOff, toggle, unknown }

class Inst {
  late OPCode op;
  late (int, int) from;
  late (int, int) to;

  Inst(this.op, this.from, this.to)
    : assert(from.$1 >= 0 && from.$2 >= 0),
      assert(to.$1 >= 0 && to.$2 >= 0);

  Inst.invalid() : this(.unknown, (0, 0), (0, 0));

  @override
  String toString() {
    return "${op.toString()} $from $to";
  }
}

(int, int) extractPosition(String s) {
  final pos = s.split(',').map((s) => int.parse(s)).toList();
  return (pos[0], pos[1]);
}

class Day6 implements Solvable {
  List<Inst> parseInst(Iterable<String> strs) {
    return strs.fold(<Inst>[], (acc, s) {
      Inst inst = .invalid();
      List<String> words = s.split(' ');

      // take the last 3 elements ["<from_pos>", "through", "<to_pos>"]
      final it = words.getRange(words.length - 3, words.length);
      inst.from = extractPosition(it.first);
      inst.to = extractPosition(it.last);

      words.removeRange(words.length - 3, words.length);

      if (words[0] == "turn") {
        if (words[1] == "on") {
          inst.op = .turnOn;
        } else if (words[1] == "off") {
          inst.op = .turnOff;
        } else {
          throw ArgumentError("invalid state '${words[1]}'");
        }
      } else if (words[0] == "toggle") {
        inst.op = .toggle;
      } else {
        throw ArgumentError("Unsupported operation ${words[0]}");
      }

      acc.add(inst);
      return acc;
    });
  }

  @override
  void solve(Stream<String> input) async {
    const int N = 1000;
    List<int> list = List.generate(N * N, (i) => 0);

    // const int N = 10;
    // List<int> list = List.generate(N * N, (i) => 0);
    // input = Stream.fromIterable([
    //   "turn on 1,0 through 9,0\n",
    //   "turn off 1,0 through 9,0\n",
    //   "turn off 1,0 through 9,0\n",
    //   "toggle 1,0 through 9,0\n",
    // ]);

    List<Inst> insts = parseInst(
      (await input.transform(const LineSplitter()).toList()),
    );

    for (final inst in insts) {
      final [x1, y1, x2, y2] = [
        inst.from.$1,
        inst.from.$2,
        inst.to.$1,
        inst.to.$2,
      ];

      for (int y = y1; y <= y2; y++) {
        if (inst.op == .turnOn || inst.op == .toggle) {
          int d = (inst.op == .turnOn) ? 1 : 2;
          for (int x = x1; x <= x2; x++) {
            list[y * N + x] += d;
          }
        } else if (inst.op == .turnOff) {
          for (int x = x1; x <= x2; x++) {
            if (list[y * N + x] <= 0) continue;
            list[y * N + x]--;
          }
        }
      }
    }

    print(list.fold<int>(0, (acc, v) => acc + v));
  }
}
