import 'package:another_authenticator_otp/parser/uri_parser_base.dart';
import 'package:test/test.dart';
import 'package:another_authenticator_otp/models/otp_algorithm.dart';
import 'package:another_authenticator_otp/models/otp_type.dart';
import 'package:another_authenticator_otp/otp.dart';
import 'package:another_authenticator_otp/otp/totp_algorithm.dart';
import 'package:another_authenticator_otp/parser/otp_uri_parser.dart';

void main() {
  // https://datatracker.ietf.org/doc/html/rfc4648#section-10
  // https://stackoverflow.com/a/54263961
  test('Base32', () {
    expect(Base32.decode("MY======"), "f".codeUnits);
    expect(Base32.decode("MZXQ===="), "fo".codeUnits);
    expect(Base32.decode("MZXW6==="), "foo".codeUnits);
    expect(Base32.decode("MZXW6YQ="), "foob".codeUnits);
    expect(Base32.decode("MZXW6YTB"), "fooba".codeUnits);
    expect(Base32.decode("MZXW6YTBOI======"), "foobar".codeUnits);
    expect(Base32.isBase32("MZXW6YTBOI======"), true);
    expect(Base32.decode("AE======"), "\x01".codeUnits);
    expect(Base32.decode("AA======"), "\x00".codeUnits);
  });

  group('TOTP', () {
    var otpUriParser = OtpAuthUriParser();

    test('Key URI 1', () {
      var parsed = otpUriParser.parse(
          "otpauth://totp/Example:alice@example.com?secret=JBSWY3DPEHPK3PXP&issuer=Example");
      expect(parsed.type, OtpType.totp);
      expect(parsed.label, "Example:alice@example.com");
      expect(parsed.algorithm, null);
      expect(parsed.digits, null);
      expect(parsed.issuer, "Example");
      expect(parsed.period, null);
      expect(parsed.secret, "JBSWY3DPEHPK3PXP");
    });

    test('Key URI Complete', () {
      var parsed = otpUriParser.parse(
          "otpauth://totp/ACME%20Co:john.doe@email.com?secret=HXDMVJECJJWSRB3HWIZR4IFUGFTMXBOZ&issuer=ACME%20Co&algorithm=SHA1&digits=6&period=30");
      expect(parsed.type, OtpType.totp);
      expect(parsed.label, "ACME Co:john.doe@email.com");
      expect(parsed.algorithm, OtpHashAlgorithm.sha1);
      expect(parsed.digits, 6);
      expect(parsed.issuer, "ACME Co");
      expect(parsed.period, 30);
      expect(parsed.secret, "HXDMVJECJJWSRB3HWIZR4IFUGFTMXBOZ");
    });

    test('Bad Number of Digits', () {
      expect(
          () => otpUriParser.parse(
              "otpauth://totp/Example:alice@example.com?secret=JBSWY3DPEHPK3PXP&issuer=Example&digits=12"),
          throwsA(predicate((e) =>
              e is UriParseException &&
              e.cause == "Unsupported number of digits")));
    });

    test('Bad Algorithm', () {
      expect(
          () => otpUriParser.parse(
              "otpauth://totp/Example:alice@example.com?secret=JBSWY3DPEHPK3PXP&issuer=Example&digits=12&algorithm=sha??"),
          throwsA(predicate((e) =>
              e is UriParseException && e.cause == "Invalid algorithm")));
    });

    test('1542791843', () {
      expect(Totp.generateCode(1542791843, "JBSWY3DPEHPK3PXP"), "092264");
    });

    test('59', () {
      expect(Totp.generateCode(59, "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ", 8),
          "94287082");
    });

    test('20000000000', () {
      expect(
          Totp.generateCode(20000000000, "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ", 8),
          "65353130");
    });

    test('Multiple', () {
      expect(
          Totp.generateCodes(
              [59, 20000000000], "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ", 8),
          ["94287082", "65353130"]);
    });

    test('Item attributes', () {
      var secret = "A";
      var digits = 8;
      var period = 60;
      var algorithm = OtpHashAlgorithm.sha256;
      var issuer = "bar";
      var label = "Example:alice@gmail.com";

      var item = OtpItem(
          OtpType.totp, secret, label, digits, period, algorithm, issuer);

      expect(item.type, OtpType.totp);
      expect(item.secret, secret);
      expect(item.label, label);
      expect(item.digits, digits);
      expect(item.period, period);
      expect(item.algorithm, algorithm);
      expect(item.issuer, issuer);
    });

    test('TOTP Item equality', () {
      var item1 = OtpItem(OtpType.totp, "A", "Example:alice@gmail.com");
      var item2 = OtpItem(OtpType.totp, "A", "Example:alice@gmail.com");
      var item3 = OtpItem(OtpType.totp, "B", "Example:alice@gmail.com");
      // Same object
      expect(item1 == item1, true);
      // Same secret (and other fields apart from id), so still equal
      expect(item1 == item2, true);
      // Secret changed
      expect(item1 == item3, false);
    });
  });
}
