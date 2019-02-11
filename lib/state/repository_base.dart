import 'dart:async' show Future;
import 'package:another_authenticator/totp/totp.dart' show TOTPItem;

/// Abstract class for loading/saving state from storage.
abstract class RepositoryBase {
  Future<List<TOTPItem>> loadState();
  Future saveState(List<TOTPItem> state);
}
