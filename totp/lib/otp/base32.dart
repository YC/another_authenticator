import 'dart:typed_data' show Uint8List, ByteData;
import 'dart:math' show min;

/// Class for decoding base32 String into List<Int>.
class Base32 {
  /// Decodes an [input] base32 String into Uint8List.
  static List<int> decode(String input) {
    // Map characters to values after removing equal signs
    var mapped = input
        .split('')
        .where((c) => c != '=') // remove '='
        .map((c) => _base32Map[c])
        .toList();

    // Initialise list
    // If completed at current index, floor division is sufficient
    // If part of previous index, floor division is still sufficient
    var length = (mapped.length * 5 / 8).floor();
    var bdata = ByteData(length);

    // For each byte
    for (int i = 0; i < length; i++) {
      // Offset of byte in bits
      int bitOffset = i * 8;

      // Start index and offset
      int start = (bitOffset / 5).floor();
      int offset = bitOffset % 5;

      // Bits to take out of 1st, 2nd and 3rd
      int n1 = 5 - offset;
      int n2 = min(5, 8 - n1);
      int n3 = 8 - n1 - n2;

      // print("$start: $n1 $n2 $n3");
      // print(Uint8List.view(bdata.buffer));

      // Bitwise OR the segments together
      int value = mapped[start]! << (8 - n1); // Right-most bits of first
      if (n2 > 0 && mapped.length > start + 1) {
        value |= (mapped[start + 1]! >> (5 - n2)) << n3; // Left-most and shift
      }
      if (n3 > 0 && mapped.length > start + 2) {
        value |= mapped[start + 2]! >> (5 - n3); // Left-most bits of third
      }
      bdata.setUint8(i, value);
    }

    return Uint8List.view(bdata.buffer);
  }

  /// Determines whether a given string is a valid base32 string.
  static bool isBase32(String input) {
    return input.split('').every((c) => c == '=' || _base32Map.containsKey(c));
  }

  /// Decode map
  static const _base32Map = {
    'A': 0,
    'B': 1,
    'C': 2,
    'D': 3,
    'E': 4,
    'F': 5,
    'G': 6,
    'H': 7,
    'I': 8,
    'J': 9,
    'K': 10,
    'L': 11,
    'M': 12,
    'N': 13,
    'O': 14,
    'P': 15,
    'Q': 16,
    'R': 17,
    'S': 18,
    'T': 19,
    'U': 20,
    'V': 21,
    'W': 22,
    'X': 23,
    'Y': 24,
    'Z': 25,
    '2': 26,
    '3': 27,
    '4': 28,
    '5': 29,
    '6': 30,
    '7': 31
  };
}
