import './authenticator_item.dart';

/// Represents app state.
///
/// Currently: holds list of TOTP items and associated manipulation functions.
class AppState {
  static const duplicateAccount = "DUPLICATE_ACCOUNT";
  static const idCollision = "ID_COLLISION";

  /// Initialise state on load.
  AppState(this._items);

  /// List of TOTP items (internal implementation).
  final List<AuthenticatorItem> _items;

  /// TOTP items as list.
  List<AuthenticatorItem> get items => _items;

  /// Adds a TOTP item to the list.
  void addItem(AuthenticatorItem item) {
    // Prevent duplicates
    if (_items.contains(item)) {
      throw Exception(duplicateAccount);
    }
    // Prevent id collisions
    if (_items.any((i) => i.id == item.id)) {
      throw Exception(idCollision);
    }
    items.add(item);
  }

  /// Replace list of TOTP items.
  void replaceItems(List<AuthenticatorItem> items) {
    _items.clear();
    _items.addAll(items);
  }

  /// Removes a TOTP item from the list.
  void removeItem(AuthenticatorItem item) {
    _items.remove(item);
  }

  /// Replaces an old TOTP item with a new one.
  void replaceItem(AuthenticatorItem oldItem, AuthenticatorItem newItem) {
    var index = _items.indexOf(oldItem);
    _items.removeAt(index);
    _items.insert(index, newItem);
  }
}
