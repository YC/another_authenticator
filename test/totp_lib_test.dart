import 'package:flutter_test/flutter_test.dart';
import 'package:another_authenticator/totp/totp_algorithm.dart';
import 'package:another_authenticator/totp/totp_uri.dart';
import 'package:another_authenticator/totp/totp_item.dart';
import 'package:another_authenticator/totp/base32.dart';

void main() {
  test('Base32', () {
    expect(Base32.decode("MY======"), "f".codeUnits);
    expect(Base32.decode("MZXQ===="), "fo".codeUnits);
    expect(Base32.decode("MZXW6==="), "foo".codeUnits);
    expect(Base32.decode("MZXW6YQ="), "foob".codeUnits);
    expect(Base32.decode("MZXW6YTB"), "fooba".codeUnits);
    expect(Base32.decode("MZXW6YTBOI======"), "foobar".codeUnits);
    expect(Base32.isBase32("MZXW6YTBOI======"), true);
  });

  test('TOTP - Key URI 1', () {
    var parsed = TOTPUri.parseURI(
        "otpauth://totp/Example:alice@example.com?secret=JBSWY3DPEHPK3PXP&issuer=Example");
    expect(parsed.accountName, "alice@example.com");
    expect(parsed.algorithm, "sha1");
    expect(parsed.digits, 6);
    expect(parsed.issuer, "Example");
    expect(parsed.period, 30);
    expect(parsed.secret, "JBSWY3DPEHPK3PXP");
  });

  test('TOTP - Key URI Complete', () {
    var parsed = TOTPUri.parseURI(
        "otpauth://totp/ACME%20Co:john.doe@email.com?secret=HXDMVJECJJWSRB3HWIZR4IFUGFTMXBOZ&issuer=ACME%20Co&algorithm=SHA1&digits=6&period=30");
    expect(parsed.accountName, "john.doe@email.com");
    expect(parsed.algorithm, "sha1");
    expect(parsed.digits, 6);
    expect(parsed.issuer, "ACME Co");
    expect(parsed.period, 30);
    expect(parsed.secret, "HXDMVJECJJWSRB3HWIZR4IFUGFTMXBOZ");
  });

  test('TOTP - Bad Key URI', () {
    try {
      TOTPUri.parseURI(
          "otpauth://totp/Example:alice@example.com?secret=JBSWY3DPEHPK3PXP&issuer=Example&digits=12");
    } catch (e) {
      expect(e.message, 'Incorrect parameters');
    }
  });

  test('TOTP - 1542791843', () {
    expect(TOTP.generateCode(1542791843, "JBSWY3DPEHPK3PXP"), "092264");
  });

  test('TOTP - 59', () {
    expect(TOTP.generateCode(59, "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ", 8),
        "94287082");
  });

  test('TOTP - 20000000000', () {
    expect(
        TOTP.generateCode(20000000000, "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ", 8),
        "65353130");
  });

  test('TOTP - Multiple', () {
    expect(
        TOTP.generateCodes(
            [59, 20000000000], "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ", 8),
        ["94287082", "65353130"]);
  });

  test('TOTP Item attributes', () {
    var id = "foo";
    var secret = "A";
    var digits = 8;
    var period = 60;
    var algorithm = "sha256";
    var issuer = "bar";
    var accountName = "foo@bar";
    var item =
        TOTPItem(id, secret, digits, period, algorithm, issuer, accountName);
    expect(item.id, id);
    expect(item.secret, secret);
    expect(item.digits, digits);
    expect(item.period, period);
    expect(item.algorithm, algorithm);
    expect(item.issuer, issuer);
    expect(item.accountName, accountName);
  });

  test('TOTP Item equality', () {
    var item1 = TOTPItem("foo", "A");
    var item2 = TOTPItem("foobar", "A");
    var item3 = TOTPItem("foo", "B");
    // Same object
    expect(item1 == item1, true);
    // Same secret (and other fields apart from id), so still equal
    expect(item1 == item2, true);
    // Secret changed
    expect(item1 == item3, false);
  });
}
