import 'package:another_authenticator_totp/models/otp_algorithm.dart';
import 'package:another_authenticator_totp/otp/code_generator_base.dart';
import 'package:another_authenticator_totp/otp/totp_algorithm.dart';

class TotpCodeGenerator implements OtpCodeGeneratorBase {
  final String secret;
  final int? digits;
  final int? period;
  final OtpHashAlgorithm? algorithm;

  TotpCodeGenerator(this.secret, [this.digits, this.period, this.algorithm]);

  @override
  String generateCode(int time) {
    return Totp.generateCode(time, secret, digits ?? 6, period ?? 30,
        algorithm ?? OtpHashAlgorithm.sha1);
  }
}
