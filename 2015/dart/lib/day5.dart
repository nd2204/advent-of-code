import 'dart:collection';
import 'dart:convert';

import 'package:main/solvable.dart';

extension BoolToInt on bool {
  int toInt() {
    return this ? 1 : 0;
  }
}

const containDoubleLetter = 1 << 2;
const containPalindrome = 1 << 3;
const containPair = 1 << 4;

List<int> Function(List<int>) _createListAdder(int pos) => ((List<int> ref) {
  ref.add(pos);
  return ref;
});

List<int> Function() _createDefaultSetter(int pos) => (() => [pos]);

class Day5 implements Solvable {
  static const Set<String> disallowed = {"ab", "cd", "pq", "xy"};
  static const Set<int> vowels = {97, 101, 105, 111, 117};

  @override
  void solve(Stream<String> input) async {
    int nice = await input.transform(const LineSplitter()).fold(0, (acc, v) {
      // the first 2 bits are reserved for vowel counts
      // the next 3 bits are flags
      int valid = 0;

      Map<String, List<int>> map = {};
      Queue<String> reason = Queue();

      var bytes = v.runes.toList();
      for (int i = 1; i < bytes.length; i++) {
        final int l = bytes[i - 1];
        final int m = bytes[i];
        final int? r = i + 1 < bytes.length ? bytes[i + 1] : null;

        // check vowel and preventing overflow of the reserved bits
        // if ((valid & 3) < 3) {
        //   valid |= min(
        //     (valid & 3) +
        //         vowels.contains(l).toInt() +
        //         ((i == bytes.length - 1) ? vowels.contains(m).toInt() : 0),
        //     3,
        //   );
        // }

        String lm = utf8.decode([l, m]);
        // String mr = utf8.decode([m, ?r]);
        // return prematurely when encounter disallowed pair;
        // if (disallowed.contains(lm) || disallowed.contains(mr)) return acc;

        // add position to pairs
        final list = map.update(
          lm,
          _createListAdder(i),
          ifAbsent: _createDefaultSetter(i),
        );

        if ((valid & containPair == 0) &&
            list.length >= 2 &&
            list.last - list.first > 1) {
          reason.add("pair=$lm");
          valid |= containPair;
        }

        // toggle contain double letter flags if found
        // if ((valid & containDoubleLetter == 0) && (m == l || m == r)) {
        //   print("containDoubleLetter ${m == l ? lm : mr}");
        //   valid |= containDoubleLetter;
        // }

        // toggle contain palindrome flags if found
        if ((valid & containPalindrome == 0) && l == r) {
          reason.add("palindrome=${utf8.decode([l, m, r!])}");
          valid |= containPalindrome;
        }
      }

      final isNice = valid ^ ((containPalindrome) | (containPair)) == 0;
      reason.addFirst("$v is ${isNice ? 'nice' : 'naughty'}");
      print(reason.join(', '));
      return acc + isNice.toInt();
    });
    print(nice);
  }
}
