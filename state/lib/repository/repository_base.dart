import 'dart:async' show Future;
import '../legacy/legacy_authenticator_item.dart';

/// Abstract class for loading/saving state from storage.
abstract class RepositoryBase {
  /// Load list of items from repository.
  Future<List<LegacyAuthenticatorItem>> loadItems();

  /// Replace list of items.
  Future replaceItems(List<LegacyAuthenticatorItem> state);

  /// Add an item to the list.
  Future<LegacyAuthenticatorItem> addItem(LegacyAuthenticatorItem item);
}
