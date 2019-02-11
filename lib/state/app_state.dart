import 'package:another_authenticator/totp/totp.dart' show TOTPItem;

/// Represents app state.
///
/// Currently: holds list of TOTP items and associated manipulation functions.
class AppState {
  static const _DUPLICATE_ACCOUNT = "DUPLICATE_ACCOUNT";
  static const _ID_COLLISION = "ID_COLLISION";

  /// Initialise state on load.
  AppState(this._items);

  /// List of TOTP items (internal implementation).
  final List<TOTPItem> _items;

  /// TOTP items as list.
  List<TOTPItem> get items => this._items;

  /// Adds a TOTP item to the list.
  void addItem(TOTPItem item) {
    // Prevent duplicates
    if (_items.contains(item)) {
      throw new Exception(_DUPLICATE_ACCOUNT);
    }
    // Prevent id collisions
    if (_items.any((_item) => _item.id == item.id)) {
      throw new Exception(_ID_COLLISION);
    }
    items.add(item);
  }

  /// Replace list of TOTP items.
  void replaceItems(List<TOTPItem> items) {
    _items.clear();
    _items.addAll(items);
  }

  /// Removes a TOTP item from the list.
  void removeItem(TOTPItem item) {
    _items.remove(item);
  }

  /// Replaces an old TOTP item with a new one.
  void replaceItem(TOTPItem oldItem, TOTPItem newItem) {
    var index = _items.indexOf(oldItem);
    _items.removeAt(index);
    _items.insert(index, newItem);
  }
}
