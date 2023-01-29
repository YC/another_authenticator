import 'dart:math' show pow;
import 'dart:typed_data' show Uint8List, Endian;
import 'package:crypto/crypto.dart' show Hash, Hmac, sha1, sha256, sha512;
import 'base32.dart' show Base32;

/// Hash algorithm to OTP
enum OtpHashAlgorithm {
  sha1,
  sha256,
  sha512;

  static OtpHashAlgorithm fromString(String str) {
    if (str == "sha1") {
      return OtpHashAlgorithm.sha1;
    } else if (str == "sha256") {
      return OtpHashAlgorithm.sha256;
    } else if (str == "sha512") {
      return OtpHashAlgorithm.sha512;
    }
    throw Exception("Unknown algorithm");
  }
}

extension _StringOperations on OtpHashAlgorithm {
  Hash toHashFunction() {
    if (this == OtpHashAlgorithm.sha1) {
      return sha1;
    } else if (this == OtpHashAlgorithm.sha256) {
      return sha256;
    } else if (this == OtpHashAlgorithm.sha512) {
      return sha512;
    }
    throw Exception("Unknown algorithm");
  }
}

/// Static class for generating TOTP codes.
///
/// References:
/// * RFC 4226, 6238
/// * https://github.com/LanceGin/dotp/blob/master/lib/src/otp.dart
/// * https://stackoverflow.com/questions/49398437
class TOTP {
  /// Formats a generated [code] to make it look nice
  static String prettyValue(String code) {
    // Length at which to split at
    int splitLength = code.length == 8 ? 4 : 3;
    // Combine 2 halves
    return '${code.substring(0, splitLength)} ${code.substring(splitLength)}';
  }

  /// Generates a TOTP value for the given attributes.
  ///
  /// Note:
  /// * [secret] should be a base32 string.
  /// * Currently only supports sha1 and sha256.
  static String generateCode(int time, String secret,
      [int digits = 6,
      int period = 30,
      OtpHashAlgorithm algorithm = OtpHashAlgorithm.sha1]) {
    // Calculate number of time steps between T0 (assumed to be Unix Epoch)
    // and current time
    int timeCounter = ((time - 0) / period).floor();
    // TOTP = HOTP(K, T)
    return _generateHOTP(secret, timeCounter, digits, algorithm);
  }

  /// Generate multiple TOTP values for the given [times].
  ///
  /// Currently only supports sha1 and sha256.
  static List<String> generateCodes(List<int> times, String secret,
      [int digits = 6,
      int period = 30,
      OtpHashAlgorithm algorithm = OtpHashAlgorithm.sha1]) {
    return times
        .map((time) => generateCode(time, secret, digits, period, algorithm))
        .toList();
  }

  /// Generates the HOTP code.
  static String _generateHOTP(
      String secret, int timeCounter, int digits, OtpHashAlgorithm algorithm) {
    var key = Base32.decode(secret);
    var bytes = Uint8List(8)
      ..buffer.asByteData().setInt64(0, timeCounter, Endian.big);

    // Determine algorithm
    var hmac = Hmac(algorithm.toHashFunction(), key);
    var digest = hmac.convert(bytes);

    int offset = digest.bytes[digest.bytes.length - 1] & 0xf;
    int binary = ((digest.bytes[offset] & 0x7f) << 24) |
        ((digest.bytes[offset + 1] & 0xff) << 16) |
        ((digest.bytes[offset + 2] & 0xff) << 8) |
        (digest.bytes[offset + 3] & 0xff);
    num otp = binary % (pow(10, digits));
    return otp.toString().padLeft(digits, "0");
  }
}
