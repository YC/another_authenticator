import 'otp_type.dart';
import 'otp_algorithm.dart';
import '../otp/code_generator_base.dart';
import '../otp/totp_code_generator.dart';
import '../parser/uri_parser_base.dart';
import '../parser/otp_uri_parser.dart' show OtpAuthUriParser;

/// Represents a TOTP item and associated information.
///
/// Has properties of accountName, issuer, secret, digits, period and algorithm,
/// as well as an id which is randomly assigned on generation.
class OtpItem {
  OtpItem(this.type, this.secret, this.label,
      [this.digits, this.period, this.algorithm, this.issuer, this.counter]);
  // TODO: Checks on construction?

  /// Type of item (Currently only supports TOTP)
  final OtpType type;

  /// Label
  final String? label;

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

  /// Counter
  final int? counter;

  // /// Creates a new TOTP item.
  // static OtpItem newTotpItem(String secret,
  //     [int digits = 6,
  //     int period = 60,
  //     OtpHashAlgorithm algorithm = OtpHashAlgorithm.sha1,
  //     String issuer = "",
  //     String accountName = ""]) {
  //   return OtpItem(secret, digits, period, algorithm, issuer, accountName);
  // }

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
  OtpItem.fromJSON(Map<String, dynamic> json)
      : type = json.containsKey('type')
            ? OtpType.fromString(json['type'])
            : OtpType.totp,
        secret = json['secret'],
        label = json.containsKey('label') ? json['label'] : null,
        digits = json['digits'],
        period = json['period'],
        algorithm = OtpHashAlgorithm.fromString(json['algorithm']),
        issuer = json['issuer'],
        counter = json.containsKey('counter') ? json['counter'] : null;

  // TODO: Handle accountName
  // OtpItem.fromJSON(Map<String, dynamic> json)
  //     : accountName = json['accountName'],
  //       issuer = json['issuer'],
  //       period = json['period'],
  //       digits = json['digits'],
  //       algorithm = OtpHashAlgorithm.values.byName(json['algorithm']),
  //       secret = json['secret'];

  /// Encode item to JSON.
  Map<String, dynamic> toJSON() => {
        'type': type.name,
        'secret': secret,
        'label': label,
        'digits': digits,
        'period': period,
        'algorithm': algorithm?.name,
        'issuer': issuer,
        'counter': counter
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
