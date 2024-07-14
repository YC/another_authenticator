import 'package:another_authenticator_state/state.dart';
import 'package:another_authenticator_totp/totp.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart' show ListEquality;

// TODO: Transition to new type
typedef BaseItemType = LegacyAuthenticatorItem;

/// Represents app state.
class AppState extends ChangeNotifier {
  final RepositoryBase<BaseItemType> _repository;

  AppState(this._repository);

  /// List of TOTP items (internal implementation).
  List<BaseItemType>? _items;

  /// TOTP items as list.
  List<BaseItemType>? get items {
    if (_items == null) {
      loadItems();
    }
    return _items;
  }

  Future loadItems() async {
    _items = await _repository.loadItems();
    notifyListeners();
  }

  /// Adds a TOTP item to the list.
  Future addItem(OtpItem item) async {
    await _repository.addItem(item);
    await loadItems();
  }

  /// Replace list of TOTP items.
  Future replaceItems(List<BaseItemType> items) async {
    await _repository.replaceItems(items);
    await loadItems();
  }

  bool itemsChanged(List<BaseItemType>? newItems) {
    return !const ListEquality().equals(items, newItems);
  }
}
