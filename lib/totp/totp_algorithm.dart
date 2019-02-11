import 'dart:math' show pow;
import 'dart:typed_data' show Uint64List;
import 'package:crypto/crypto.dart' show sha1, sha256, Hmac;
import 'base32.dart' show Base32;

/// Static class for generating TOTP codes.
///
/// References:
/// * RFC 4226, 6238
/// * https://github.com/LanceGin/dotp/blob/master/lib/src/otp.dart
/// * https://stackoverflow.com/questions/49398437
class TOTP {
  /// Generates a TOTP value for the given attributes.
  ///
  /// Note:
  /// * [secret] should be a base32 string.
  /// * Currently only supports sha1 and sha256.
  static String generateCode(int time, String secret,
      [int digits = 6, int period = 30, String algorithm = 'sha1']) {
    // Calculate number of time steps between T0 (assumed to be Unix Epoch)
    // and current time
    int timeCounter = ((time - 0) / period).floor();
    // TOTP = HOTP(K, T)
    return _generateHOTP(secret, timeCounter, digits, algorithm);
  }

  /// Formats a generated [code] to make it look nice
  static String prettyValue(String code) {
    // Length at which to split at
    int splitLength = code.length == 8 ? 4 : 3;
    // Combine 2 halves
    return code.substring(0, splitLength) + ' ' + code.substring(splitLength);
  }

  /// Generate multiple TOTP values for the given [times].
  ///
  /// Currently only supports sha1 and sha256.
  static List<String> generateCodes(List<int> times, String secret,
      [int digits = 6, int period = 30, String algorithm = 'sha1']) {
    return times
        .map((time) => generateCode(time, secret, digits, period, algorithm))
        .toList();
  }

  /// Generates the HOTP code.
  static String _generateHOTP(
      String secret, int timeCounter, int digits, String algorithm) {
    var key = Base32.decode(secret);
    var bytes = new Uint64List.fromList([timeCounter]).buffer.asUint8List();

    // Determine algorithm
    var hash;
    if (algorithm == "sha1") {
      hash = sha1;
    } else if (algorithm == "sha256") {
      hash = sha256;
    }
    var hmac = new Hmac(hash, key);

    var digest = hmac.convert(bytes.reversed.toList());

    int offset = digest.bytes[digest.bytes.length - 1] & 0xf;
    int binary = ((digest.bytes[offset] & 0x7f) << 24) |
        ((digest.bytes[offset + 1] & 0xff) << 16) |
        ((digest.bytes[offset + 2] & 0xff) << 8) |
        (digest.bytes[offset + 3] & 0xff);
    int otp = binary % (pow(10, digits));
    return otp.toString().padLeft(digits, "0");
  }
}
