import 'otp_type.dart';
import 'otp_algorithm.dart';
import '../otp/code_generator_base.dart';
import '../otp/totp_code_generator.dart';
import '../parser/uri_parser_base.dart';
import '../parser/otp_uri_parser.dart' show OtpAuthUriParser;

/// Represents an OTP item and associated information.
class OtpItem {
  OtpItem(this.type, this.secret, this.label,
      [this.digits,
      this.period,
      this.algorithm,
      this.issuer,
      this.counter,
      this.originalUri]);

  /// Type of item (Currently only supports TOTP)
  final OtpType type;

  /// Label
  final String label;

  /// Secret key (in base32)
  final String secret;

  /// Issuer
  final String? issuer;

  /// Algorithm (sha1/sha256/sha512)
  final OtpHashAlgorithm? algorithm;

  /// Number of digits (of code)
  final int? digits;

  /// Time period
  final int? period;

  /// Counter (HOTP only)
  final int? counter;

  /// URI in original form (if scanned/imported)
  final String? originalUri;

  /// Parses a TOTP key URI and returns a TOTPItem.
  static final List<UriParserBase> _parsers = [OtpAuthUriParser()];
  static OtpItem fromUri(String uri) {
    for (final parser in _parsers) {
      if (parser.canParse(uri)) {
        return parser.parse(uri);
      }
    }
    throw FormatException("Unrecognized URI scheme, cannot parse...");
  }

  /// Generates a formatted TOTP value for the given [time].
  String getPrettyCode(int time) {
    return _prettyValue(getCode(time));
  }

  /// Generates a TOTP value for the given [time].
  String getCode(int time) {
    OtpCodeGeneratorBase gen =
        TotpCodeGenerator(secret, digits, period, algorithm);
    return gen.generateCode(time);
  }

  /// Get period that code is valid for.
  /// Currently, HOTP is not supported, so type is yet optional.
  int getPeriod() {
    OtpCodeGeneratorBase gen =
        TotpCodeGenerator(secret, digits, period, algorithm);
    return gen.getPeriod();
  }

  /// Get Issuer.
  String? getIssuer() {
    // Use the issuer parameter
    if (issuer != null) {
      return issuer!;
    }

    // Extract it out of the label
    // label = accountname / issuer (“:” / “%3A”) *”%20” accountname
    if (label.contains(':')) {
      return label.split(':')[0];
    }

    return null;
  }

  /// Get account name
  String getAccountName() {
    if (!label.contains(':')) {
      return label;
    }
    return label.split(':')[1];
  }

  /// Returns a placeholder representation of the generated code.
  String get placeholder {
    if (digits == 8) {
      return '···· ····';
    }
    return '··· ···';
  }

  /// Formats a generated [code] to make it look nice
  static String _prettyValue(String code) {
    // Length at which to split at
    int splitLength = code.length == 8 ? 4 : 3;
    // Combine 2 halves
    return '${code.substring(0, splitLength)} ${code.substring(splitLength)}';
  }

  /// Decode item from JSON.
  OtpItem.fromJson(Map<String, dynamic> json)
      : type = json.containsKey('type')
            ? OtpType.fromString(json['type'])
            : OtpType.totp,
        secret = json['secret'],
        label = json.containsKey('label')
            ? json['label']
            : json.containsKey('accountName') && json['accountName'] != ''
                ? json.containsKey('issuer') && json['issuer'] != ''
                    ? "${json['issuer']}:${json['accountName']}"
                    : json['accountName']
                : "",
        digits = json['digits'],
        period = json['period'],
        algorithm = json['algorithm'] == null
            ? null
            : OtpHashAlgorithm.fromString(json['algorithm']),
        issuer = json['issuer'],
        counter = json.containsKey('counter') ? json['counter'] : null,
        originalUri = json.containsKey('uri') ? json['uri'] : null;

  /// Encode item to JSON.
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'secret': secret,
        'label': label,
        'digits': digits,
        'period': period,
        'algorithm': algorithm?.name,
        'issuer': issuer,
        'counter': counter,
        'uri': originalUri
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OtpItem &&
          type == other.type &&
          secret == other.secret &&
          label == other.label &&
          digits == other.digits &&
          period == other.period &&
          algorithm == other.algorithm &&
          issuer == other.issuer &&
          counter == other.counter;

  @override
  int get hashCode =>
      type.hashCode ^
      secret.hashCode ^
      label.hashCode ^
      digits.hashCode ^
      period.hashCode ^
      algorithm.hashCode ^
      issuer.hashCode ^
      counter.hashCode;
}
