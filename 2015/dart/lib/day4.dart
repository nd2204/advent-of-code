import 'dart:convert';

import 'package:main/solvable.dart';
import 'package:crypto/crypto.dart';

Digest mine(List<int> secret, int nonce) {
  return md5.convert([...secret, ...nonce.toString().runes]);
}

bool digestBytesValid(List<int> bytes, int leadingZero) {
  assert(leadingZero > 0 && leadingZero < bytes.length);
  final num = leadingZero ~/ 2;

  // explain: the first to the second last byte should be 0,
  // the last byte:
  //   should also be 0 if leadingZero is even
  //   or last <= 0x0f if leadingZero is odd
  if (leadingZero % 2 == 0) {
    return bytes.take(num).every((v) => v == 0);
  } else {
    return bytes.take(num).every((v) => v == 0) && bytes[num] < 16;
  }
}

class Day4 implements Solvable {
  @override
  void solve(Stream<String> input) async {
    var secretBytes = (await input.first).trim().runes.toList();
    int nonce = 0;

    var digest = mine(secretBytes, nonce);
    while (!digestBytesValid(digest.bytes, 6)) {
      digest = mine(secretBytes, ++nonce);
    }

    print("mined $nonce");
  }
}
