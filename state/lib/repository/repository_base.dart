import 'dart:async' show Future;
import '../authenticator_item.dart';

/// Abstract class for loading/saving state from storage.
abstract class RepositoryBase {
  /// Whether repository has state (used for migration).
  Future<bool> hasState();

  /// Load list of items from repository.
  Future<List<AuthenticatorItem>> loadItems();

  /// Save list of items.
  Future saveItems(List<AuthenticatorItem> state);

  /// Add an item to the list.
  Future<AuthenticatorItem> addItem(AuthenticatorItem item);
}
