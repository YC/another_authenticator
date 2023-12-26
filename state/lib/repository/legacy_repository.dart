import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:another_authenticator_state/file_storage_base.dart';

import '../authenticator_item.dart';
import './repository_base.dart' show RepositoryBase;

/// Is used to load/save state to JSON file.
///
/// Currently uses FileStorage to do so.
class LegacyRepository implements RepositoryBase {
  LegacyRepository(this._fileStorage);

  // Current file version
  static const _currentVersion = 1;

  // Filename of JSON
  static const _stateFilename = "items.json";

  // Used for loading/saving files
  final FileStorageBase _fileStorage;

  // Items
  List<AuthenticatorItem> _items = [];

  @override
  Future<bool> hasState() {
    return _fileStorage.hasFile(_stateFilename);
  }

  /// Loads state from storage.
  @override
  Future<List<AuthenticatorItem>> loadItems() async {
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
        .map((i) => AuthenticatorItem.fromJSON(i))
        .toList();
    _items = items;
    return items;
  }

  /// Saves [state] to storage.
  @override
  Future saveItems(List<AuthenticatorItem> state) async {
    // Encode
    var items = state.map((i) => i.toJSON()).toList();
    var version = _currentVersion;
    var str = json.encode({'items': items, 'version': version});

    // Save to file
    return await _fileStorage.writeFile(_stateFilename, str).then((_) => {});
  }

  @override
  Future<AuthenticatorItem> addItem(AuthenticatorItem item) async {
    _items.add(item);
    await saveItems(_items);
    return item;
  }
}
