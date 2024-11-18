enum OtpType {
  hotp,
  totp;

  static OtpType fromString(String str) {
    if (str.toLowerCase() == "totp") {
      return OtpType.totp;
    } else if (str.toLowerCase() == "hotp") {
      return OtpType.hotp;
    }
    throw Exception("Unsupported type");
  }
}
