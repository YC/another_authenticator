import '../otp.dart';

abstract interface class UriParserBase {
  bool canParse(String uri);
  OtpItem parse(String uri);
}

class UriParseException implements Exception {
  String cause;
  UriParseException(this.cause);
}
