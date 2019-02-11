import 'totp_item.dart' show TOTPItem;

/// Parses TOTP key URI into TOTPItems.
///
/// Reference:
/// * https://github.com/google/google-authenticator/wiki/Key-Uri-Format
class TOTPUri {
  /// Parses a TOTP key URI and returns a TOTP object
  static TOTPItem parseURI(String uri) {
    // Use dart-core/Uri to parse
    var parsed = Uri.parse(uri);

    // Check scheme
    if (parsed.scheme != "otpauth" || parsed.authority != 'totp') {
      throw new FormatException("Not TOTP URI");
    }

    // Extract issuer/account name
    if (parsed.pathSegments.length > 1) {
      throw new FormatException("Should have more than 1 path segment");
    }
    var pathSplit = parsed.pathSegments[0].split(':');
    var issuer = pathSplit[0];
    var accountName = pathSplit.length > 1 ? pathSplit[1] : '';

    // Extract algorithm, digits, period and secret
    var algorithm = "sha1";
    var digits = 6;
    var period = 30;
    var secret = "";
    if (!parsed.queryParameters.containsKey("secret")) {
      throw new FormatException("Query parameter does not contain secret");
    }
    secret = parsed.queryParameters["secret"];
    if (parsed.queryParameters.containsKey("algorithm")) {
      algorithm = parsed.queryParameters["algorithm"].toLowerCase();
    }
    if (parsed.queryParameters.containsKey("digits")) {
      digits = int.parse(parsed.queryParameters["digits"]);
    }
    if (parsed.queryParameters.containsKey("period")) {
      period = int.parse(parsed.queryParameters["period"]);
    }

    try {
      return TOTPItem.newTOTPItem(
          secret, digits, period, algorithm, issuer, accountName);
    } catch (error) {
      throw new FormatException("Incorrect parameters");
    }
  }
}
