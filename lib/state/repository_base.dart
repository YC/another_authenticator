import 'dart:async' show Future;
import 'package:another_authenticator/state/authenticator_item.dart';

/// Abstract class for loading/saving state from storage.
abstract class RepositoryBase {
  Future<List<AuthenticatorItem>> loadState();
  Future saveState(List<AuthenticatorItem> state);
}
