import 'dart:async' show Future;
import 'package:another_authenticator_totp/totp.dart' show TotpItem;

/// Abstract class for loading/saving state from storage.
abstract class RepositoryBase {
  Future<List<TotpItem>> loadState();
  Future saveState(List<TotpItem> state);
}
