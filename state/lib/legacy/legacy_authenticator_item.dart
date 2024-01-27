import 'package:another_authenticator_totp/totp.dart';
import 'package:another_authenticator_totp/totp_algorithm.dart';
import 'package:uuid/uuid.dart';

class LegacyAuthenticatorItem {
  /// Legacy GUID id
  final String id;

  final TotpItem totp;

  LegacyAuthenticatorItem(this.id, this.totp);

  static LegacyAuthenticatorItem newAuthenticatorItemFromUri(String uri) {
    var id = Uuid().v4();
    return LegacyAuthenticatorItem(id, TotpItem.fromUri(uri));
  }

  static LegacyAuthenticatorItem newAuthenticatorItem(String secret,
      [int digits = 6,
      int period = 60,
      OtpHashAlgorithm algorithm = OtpHashAlgorithm.sha1,
      String issuer = "",
      String accountName = ""]) {
    var item = TotpItem(secret, digits, period, algorithm, issuer, accountName);
    var id = Uuid().v4();
    return LegacyAuthenticatorItem(id, item);
  }

  /// Legacy decode.
  LegacyAuthenticatorItem.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        totp = TotpItem.fromJSON(json);

  /// Legacy encode.
  Map<String, dynamic> toMap() => {
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
      other is LegacyAuthenticatorItem && id == other.id && totp == other.totp;

  @override
  int get hashCode => id.hashCode ^ totp.hashCode;
}
