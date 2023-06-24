import 'package:another_authenticator_totp/totp.dart';
import 'package:another_authenticator_totp/totp_algorithm.dart';
import 'package:uuid/uuid.dart';

class AuthenticatorItem {
  final String id;
  final TotpItem totp;

  AuthenticatorItem(this.id, this.totp);

  static AuthenticatorItem newAuthenticatorItemFromUri(String uri) {
    var id = Uuid().v4();
    return AuthenticatorItem(id, TotpItem.fromUri(uri));
  }

  static AuthenticatorItem newAuthenticatorItem(String secret,
      [int digits = 6,
      int period = 60,
      OtpHashAlgorithm algorithm = OtpHashAlgorithm.sha1,
      String issuer = "",
      String accountName = ""]) {
    var item = TotpItem(secret, digits, period, algorithm, issuer, accountName);
    var id = Uuid().v4();
    return AuthenticatorItem(id, item);
  }

  /// Decode item from JSON.
  AuthenticatorItem.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        totp = TotpItem.fromJSON(json);

  /// Encode item to JSON.
  Map<String, dynamic> toJSON() => {
        'id': id,
        'accountName': totp.accountName,
        'issuer': totp.issuer,
        'secret': totp.secret,
        'digits': totp.digits,
        'period': totp.period,
        'algorithm': totp.algorithm.name
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthenticatorItem && id == other.id && totp == other.totp;

  @override
  int get hashCode => id.hashCode ^ totp.hashCode;
}
