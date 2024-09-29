import 'code_generator_base.dart';
import '../models/otp_algorithm.dart';
import '../otp/totp_algorithm.dart';

class TotpCodeGenerator implements OtpCodeGeneratorBase {
  final String secret;
  final int? digits;
  final int? period;
  final OtpHashAlgorithm? algorithm;

  static const _defaultDigits = 6;
  static const _defaultAlgorithm = OtpHashAlgorithm.sha1;
  static const _defaultPeriod = 30;

  TotpCodeGenerator(this.secret, [this.digits, this.period, this.algorithm]);

  @override
  String generateCode(int time) {
    return Totp.generateCode(time, secret, digits ?? _defaultDigits,
        period ?? _defaultPeriod, algorithm ?? _defaultAlgorithm);
  }

  @override
  int getPeriod() {
    return period ?? _defaultPeriod;
  }
}
