import 'dart:convert';
import 'dart:math';

import 'package:main/solvable.dart';

class AccumulateResult {
  int totalWrappingPaper;
  int totalRibbon;

  AccumulateResult({this.totalWrappingPaper = 0, this.totalRibbon = 0});
}

class Day2 implements Solvable {
  @override
  void solve(Stream<String> input) async {
    AccumulateResult result = await input.transform(const LineSplitter()).fold(
      AccumulateResult(),
      (acc, line) {
        final dims = line.split('x').map((e) => int.parse(e)).toList();
        final [l, w, h] = dims;
        final [lw, lh, wh] = [l * w, l * h, w * h];

        final slack = min(lw, min(lh, wh));
        final total = (2 * lw) + (2 * lh) + (2 * wh) + slack;
        acc.totalWrappingPaper += total;

        dims.sort();
        final ribbon = dims.take(2).fold(0, (acc, v) => acc + v * 2);
        acc.totalRibbon += (l * w * h) + ribbon;
        return acc;
      },
    );
    print(result.totalWrappingPaper);
    print(result.totalRibbon);
  }
}
