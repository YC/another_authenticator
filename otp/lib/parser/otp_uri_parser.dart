import "uri_parser_base.dart";
import '../models/otp_type.dart';
import '../models/otp_algorithm.dart';
import '../models/otp_item.dart';

/// Parses OTP URI into OtpItem.
///
/// Reference:
/// * https://github.com/google/google-authenticator/wiki/Key-Uri-Format
class OtpAuthUriParser implements UriParserBase {
  /// Whether URI can be parsed by current parser
  @override
  bool canParse(String uri) {
    try {
      var parsed = Uri.parse(uri);
      return parsed.scheme == "otpauth";
    } on FormatException {
      return false;
    }
  }

  /// Parses a Key URI and returns an OTP object
  @override
  OtpItem parse(String uri) {
    var parsed = Uri.parse(uri);

    if (parsed.scheme != "otpauth") {
      throw UriParseException("Not OTP URI");
    }

    var typeValue = parsed.authority.toLowerCase();
    if (typeValue != "totp" && typeValue != "hotp") {
      throw UriParseException("Unsupported type");
    }
    var type = OtpType.fromString(typeValue);

    if (parsed.pathSegments.length != 1) {
      throw UriParseException("Should have 1 path segment");
    }
    var label = parsed.pathSegments[0];

    // secret: Mandatory, key value encoded in Base32
    if (!parsed.queryParameters.containsKey("secret")) {
      throw UriParseException("URI does not contain secret");
    }
    var secret = parsed.queryParameters["secret"]!;

    // issuer: Recommended, if absent, issuer from label may be taken
    String? issuer;
    if (parsed.queryParameters.containsKey("issuer")) {
      issuer = parsed.queryParameters["issuer"]!;
    }

    // algorithm: Optional, SHA1 (Default), SHA256, SHA512
    OtpHashAlgorithm? algorithm;
    if (parsed.queryParameters.containsKey("algorithm")) {
      var algorithmValue = parsed.queryParameters["algorithm"]!;
      if (!OtpHashAlgorithm.isValid(algorithmValue)) {
        throw UriParseException("Invalid algorithm");
      }
      algorithm = OtpHashAlgorithm.fromString(algorithmValue);
    }

    // digits: Optional, 6 (Default), number of digits in output
    int? digits;
    if (parsed.queryParameters.containsKey("digits")) {
      digits = int.parse(parsed.queryParameters["digits"]!);
      if (digits != 6 && digits != 8) {
        throw UriParseException("Unsupported number of digits");
      }
    }

    // period: Optional, 30 (Default), time period in seconds
    int? period;
    if (parsed.queryParameters.containsKey("period")) {
      period = int.parse(parsed.queryParameters["period"]!);
      if (period <= 0) {
        throw UriParseException("Invalid period");
      }
    }

    // counter: Optional, Initial counter value for hotp
    int? counter;
    if (parsed.queryParameters.containsKey("counter")) {
      counter = int.parse(parsed.queryParameters["counter"]!);
      if (counter <= 0) {
        throw UriParseException("Invalid counter value");
      }
    }

    return OtpItem(
        type, secret, label, digits, period, algorithm, issuer, counter, uri);
  }
}
