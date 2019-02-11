import 'package:uuid/uuid.dart' show Uuid;
import 'base32.dart' show Base32;
import 'totp_algorithm.dart' show TOTP;
import 'totp_uri.dart' show TOTPUri;

/// Represents a TOTP item and associated information.
///
/// Has properties of accountName, issuer, secret, digits, period and algorithm,
/// as well as an id which is randomly assigned on generation.
class TOTPItem {
  TOTPItem(this.id, this.secret,
      [this.digits = 6,
      this.period = 30,
      this.algorithm = "sha1",
      this.issuer = "",
      this.accountName = ""])
      : assert(Base32.isBase32(secret) && secret != ''),
        assert(digits == 6 || digits == 8),
        assert(period > 0),
        assert(algorithm == 'sha1' || algorithm == 'sha256');

  /// ID of item
  final String id;

  /// Account name
  final String accountName;

  /// Issuer
  final String issuer;

  /// Secret key (in base32)
  final String secret;

  /// Number of digits (of code)
  final int digits;

  /// Time period
  final int period;

  /// Algorithm (sha1/sha256/sha512)
  final String algorithm;

  /// Creates a new TOTP item.
  static TOTPItem newTOTPItem(String secret,
      [int digits = 6,
      int period = 60,
      String algorithm = "sha1",
      String issuer = "",
      String accountName = ""]) {
    String id = Uuid().v4();
    return TOTPItem(id, secret, digits, period, algorithm, issuer, accountName);
  }

  /// Parses a TOTP key URI and returns a TOTPItem.
  static TOTPItem fromUri(String uri) {
    return TOTPUri.parseURI(uri);
  }

  /// Generates a formatted TOTP value for the given [time].
  String getPrettyCode(int time) {
    return TOTP.prettyValue(
        TOTP.generateCode(time, secret, digits, period, algorithm));
  }

  /// Generates a TOTP value for the given [time].
  String getCode(int time) {
    return TOTP.generateCode(time, secret, digits, period, algorithm);
  }

  /// Returns a placeholder representation of the generated code.
  String get placeholder {
    if (digits == 8) {
      return '···· ····';
    }
    return '··· ···';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TOTPItem &&
          accountName == other.accountName &&
          issuer == other.issuer &&
          secret == other.secret &&
          digits == other.digits &&
          period == other.period &&
          algorithm == other.algorithm;

  @override
  int get hashCode =>
      accountName.hashCode ^
      issuer.hashCode ^
      period.hashCode ^
      digits.hashCode ^
      algorithm.hashCode ^
      secret.hashCode;

  /// Decode item from JSON.
  TOTPItem.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        accountName = json['accountName'],
        issuer = json['issuer'],
        period = json['period'],
        digits = json['digits'],
        algorithm = json['algorithm'],
        secret = json['secret'];

  /// Encode item to JSON.
  Map<String, dynamic> toJSON() => {
        'id': id,
        'accountName': accountName,
        'issuer': issuer,
        'secret': secret,
        'digits': digits,
        'period': period,
        'algorithm': algorithm
      };
}
