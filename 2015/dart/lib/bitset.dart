import 'dart:convert';

extension IntToBinary on int {
  String toBinaryString([int length = 64]) {
    int x = this;
    final int zeroUtf8 = utf8.encode('0').first;
    List<int> bytes = List.generate(
      length,
      (i) => zeroUtf8, // 0 in utf8
      growable: false,
    );
    for (int i = 0; i < length; ++i) {
      bytes[i] += (x & 1);
      x >>= 1;
    }
    return utf8.decode(bytes);
  }
}

int popcount64(int v) {
  int count = 0;
  int x = v & Bitset.mask64;
  while (x != 0) {
    count++;
    x &= x - 1;
  }
  return count;
}

class Bitset {
  static const int mask64 = 0xffffffffffffffff;
  static const int maxBit = 64;

  late List<int> bit;
  late int allOnes = (maxBit == 64) ? mask64 : ((1 << maxBit) - 1);

  int n;

  Iterator<int> get iterator => bit.iterator;

  Bitset(this.n) {
    bit = List.generate((n / maxBit).ceil(), (_) => 0, growable: false);
  }

  int mask0To(int b) {
    if (b == (maxBit - 1)) return allOnes;
    return (1 << (b + 1)) - 1;
  }

  int maskFrom(int bitPos) {
    if (bitPos == 0) return allOnes;
    return allOnes ^ mask0To(bitPos - 1);
  }

  void toggleRange(int l, int r) {
    assert(l <= r && l >= 0 && r < n);
    final [wL, wR] = [(l ~/ maxBit), (r ~/ maxBit)]; // word positions
    final [bL, bR] = [
      l & (maxBit - 1),
      r & (maxBit - 1),
    ]; // number of bit to mask
    // print("$wL, $wR");

    int i = wL;

    int maskLeft = maskFrom(bL);
    int maskRight = mask0To(bR);

    // updating only one word
    if (wL == wR) {
      int mask = maskLeft & maskRight;
      bit[wL] ^= mask;
      return;
    }

    // update left words
    if (bL != 0) {
      bit[wL] ^= maskLeft;
      i++;
    }

    // handle toggle full word case
    for (; i < wR; i++) {
      bit[i] ^= allOnes;
    }

    if (bR != (maxBit - 1)) {
      bit[i] ^= maskRight;
    } else {
      bit[i] ^= allOnes;
    }
  }

  void setRange(int l, int r, bool val) {
    assert(l <= r && l >= 0 && r < n);
    final [wL, wR] = [(l ~/ maxBit), (r ~/ maxBit)]; // word positions
    final [bL, bR] = [
      l & (maxBit - 1),
      r & (maxBit - 1),
    ]; // number of bit to mask
    // print("$wL, $wR");

    int i = wL;
    int maskLeft = maskFrom(bL);
    int maskRight = mask0To(bR);

    // updating only one word
    if (wL == wR) {
      int mask = maskLeft & maskRight;
      bit[wL] = val ? bit[wL] | mask : bit[wL] & (~mask & mask64);
      return;
    }

    // update left words
    if (bL != 0) {
      bit[wL] = val ? bit[wL] | maskLeft : bit[wL] & (~maskLeft & mask64);
      i++;
    }

    // handle set full word case
    for (; i < wR; i++) {
      bit[i] = val ? bit[i] | allOnes : bit[i] & (~allOnes & mask64);
    }

    if (bR != (maxBit - 1)) {
      bit[wR] = val ? bit[wR] | maskRight : bit[wR] & (~maskRight & mask64);
    } else {
      bit[wR] = val ? bit[wR] | allOnes : bit[wR] & (~allOnes & mask64);
    }
  }

  @override
  String toString() {
    List<String> ret = [];
    for (final b in bit) {
      ret.add(b.toBinaryString());
    }
    return "[${ret.join(",")}]";
  }
}
