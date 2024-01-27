import 'package:another_authenticator_state/state.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart' show ListEquality;

/// Represents app state.
class AppState extends ChangeNotifier {
  final RepositoryBase _repository;

  AppState(this._repository);

  /// List of TOTP items (internal implementation).
  List<LegacyAuthenticatorItem>? _items;

  /// TOTP items as list.
  List<LegacyAuthenticatorItem>? get items {
    if (_items == null) {
      loadItems();
    }
    return _items;
  }

  void loadItems() async {
    _items = await _repository.loadItems();
    notifyListeners();
  }

  /// Adds a TOTP item to the list.
  Future addItem(LegacyAuthenticatorItem item) async {
    await _repository.addItem(item);
    loadItems();
  }

  /// Replace list of TOTP items.
  Future replaceItems(List<LegacyAuthenticatorItem> items) async {
    await _repository.replaceItems(items);
    loadItems();
  }

  bool itemsChanged(List<LegacyAuthenticatorItem>? newItems) {
    return !const ListEquality().equals(items, newItems);
  }
}
