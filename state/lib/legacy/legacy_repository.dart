import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:another_authenticator_state/file_storage_base.dart';
import 'package:another_authenticator_totp/totp.dart';

import './legacy_authenticator_item.dart';
import '../repository/repository_base.dart' show RepositoryBase;

/// Is used to load/save state to JSON file.
///
/// Currently uses FileStorage to do so.
class LegacyRepository implements RepositoryBase<LegacyAuthenticatorItem> {
  LegacyRepository(this._fileStorage);

  // Current file version
  static const _currentVersion = 1;

  // Filename of JSON
  static const _stateFilename = "items.json";

  // Used for loading/saving files
  final FileStorageBase _fileStorage;

  // Items
  List<LegacyAuthenticatorItem> _items = [];

  Future<bool> hasState() {
    return _fileStorage.hasFile(_stateFilename);
  }

  /// Loads state from storage.
  @override
  Future<List<LegacyAuthenticatorItem>> loadItems() async {
    // If file doesn't exist, then initialise empty state

    // Load/decode file
    var str = await _fileStorage.readFile(_stateFilename);
    if (str == null) {
      return [];
    }

    Map<String, dynamic> decoded = json.decode(str);
    var version = decoded['version'];

    // If version is not current, bring it up to current
    if (version != _currentVersion) {
      throw Exception("Unknown file version");
    }

    // Decode and return items
    // Adapted from: https://stackoverflow.com/questions/50360443
    var itemsDecoded = decoded['items'];
    var items = (itemsDecoded as List)
        .map((i) => LegacyAuthenticatorItem.fromMap(i))
        .toList();
    _items = items;
    return items;
  }

  /// Saves [state] to storage.
  @override
  Future replaceItems(List<LegacyAuthenticatorItem> state) async {
    return await _saveItems(state);
  }

  @override
  Future<LegacyAuthenticatorItem> addItem(OtpItem item) async {
    var legacyAuthenticatorItem =
        LegacyAuthenticatorItem.newAuthenticatorItem(item);
    _items.add(legacyAuthenticatorItem);
    await _saveItems(_items);
    return legacyAuthenticatorItem;
  }

  Future _saveItems(List<LegacyAuthenticatorItem> items) async {
    // Encode
    var itemsMapped = items.map((i) => i.toMap()).toList();
    var version = _currentVersion;
    var str = json.encode({'items': itemsMapped, 'version': version});

    // Save to file
    return await _fileStorage.writeFile(_stateFilename, str).then((_) => {});
  }
}
