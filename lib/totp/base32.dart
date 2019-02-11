import 'dart:typed_data' show Uint8List;

/// Class for decoding base32 String into List<Int>.
class Base32 {
  /// Decodes an [input] base32 String into Uint8List.
  static List<int> decode(String input) {
    // Map characters after removing equal signs
    var mapped =
        input.split('').where((c) => c != '=').map((c) => _BASE32_MAP[c]);
    if (mapped.contains(null)) {
      throw new FormatException("Input is invalid");
    }

    // Convert to binary string segments and combine
    var bin = mapped.map((s) => s.toRadixString(2).padLeft(5, '0')).join('');

    // Split into 8 bit string segments
    var bitList = new List<String>();
    var segment = "";
    for (int i = 0; i < bin.length; i++) {
      segment += bin[i];
      if (segment.length == 8) {
        bitList.add(segment);
        segment = "";
      }
    }

    // Convert 8 bit strings to ints
    var intList = bitList.map((s) => int.parse(s, radix: 2)).toList();
    return Uint8List.fromList(intList);
  }

  /// Determines whether a given string is a valid base32 string.
  static bool isBase32(String input) {
    return input.split('').every((c) => c == '=' || _BASE32_MAP.containsKey(c));
  }

  /// Decode map
  static const _BASE32_MAP = {
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
