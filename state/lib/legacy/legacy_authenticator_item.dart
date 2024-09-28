import 'package:another_authenticator_otp/otp.dart';
import 'package:uuid/uuid.dart';

class LegacyAuthenticatorItem {
  /// Legacy GUID id
  final String id;

  final OtpItem totp;

  LegacyAuthenticatorItem(this.id, this.totp);

  static LegacyAuthenticatorItem newAuthenticatorItemFromUri(String uri) {
    var id = Uuid().v4();
    return LegacyAuthenticatorItem(id, OtpItem.fromUri(uri));
  }

  static LegacyAuthenticatorItem newAuthenticatorItem(OtpItem item) {
    var id = Uuid().v4();
    return LegacyAuthenticatorItem(id, item);
  }

  // static LegacyAuthenticatorItem newAuthenticatorItem(String secret,
  //     [int digits = 6,
  //     int period = 60,
  //     OtpHashAlgorithm algorithm = OtpHashAlgorithm.sha1,
  //     String issuer = "",
  //     String accountName = ""]) {
  //   var item = TotpItem(secret, digits, period, algorithm, issuer, accountName);
  //   var id = Uuid().v4();
  //   return LegacyAuthenticatorItem(id, item);
  // }

  /// Legacy decode.
  LegacyAuthenticatorItem.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        totp = OtpItem.fromJSON(json);

  /// Legacy encode.
  Map<String, dynamic> toMap() {
    return {'id': id, ...totp.toJSON()};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LegacyAuthenticatorItem && id == other.id && totp == other.totp;

  @override
  int get hashCode => id.hashCode ^ totp.hashCode;
}
