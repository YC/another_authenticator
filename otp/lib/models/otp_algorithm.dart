import 'package:crypto/crypto.dart';

/// Hash algorithm to OTP
enum OtpHashAlgorithm {
  sha1,
  sha256,
  sha512;

  static OtpHashAlgorithm fromString(String str) {
    if (str.toLowerCase() == "sha1") {
      return OtpHashAlgorithm.sha1;
    } else if (str.toLowerCase() == "sha256") {
      return OtpHashAlgorithm.sha256;
    } else if (str.toLowerCase() == "sha512") {
      return OtpHashAlgorithm.sha512;
    }
    throw Exception("Unsupported algorithm");
  }

  static bool isValid(String str) {
    return OtpHashAlgorithm.values.any((v) => v.name == str.toLowerCase());
  }
}

extension StringOperations on OtpHashAlgorithm {
  Hash toHashFunction() {
    if (this == OtpHashAlgorithm.sha1) {
      return sha1;
    } else if (this == OtpHashAlgorithm.sha256) {
      return sha256;
    } else if (this == OtpHashAlgorithm.sha512) {
      return sha512;
    }
    throw Exception("Unsupported algorithm");
  }
}
