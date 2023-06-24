import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:another_authenticator_state/file_storage_base.dart';

import './authenticator_item.dart';
import './repository_base.dart' show RepositoryBase;

/// Is used to load/save state.
///
/// Currently uses FileStorage to do so.
class Repository implements RepositoryBase {
  Repository(this._fileStorage);

  // Used for loading/saving files
  final FileStorageBase _fileStorage;

  // Current file version
  static const currentVersion = 1;

  /// Loads state from storage.
  @override
  Future<List<AuthenticatorItem>> loadState() async {
    // If file doesn't exist, then initialise empty state
    var exists = await _fileStorage.fileExists();
    if (!exists) {
      return [];
    }

    // Load/decode file
    var str = await _fileStorage.readFile();
    Map<String, dynamic> decoded = json.decode(str);
    var version = decoded['version'];

    // If version is not current, bring it up to current
    if (version != currentVersion) {
      throw Exception("Unknown file version");
    }

    // Decode and return items
    // Adapted from: https://stackoverflow.com/questions/50360443
    var items = decoded['items'];
    return (items as List).map((i) => AuthenticatorItem.fromJSON(i)).toList();
  }

  /// Saves [state] to storage.
  @override
  Future saveState(List<AuthenticatorItem> state) {
    // Encode
    var items = state.map((i) => i.toJSON()).toList();
    var version = currentVersion;
    var str = json.encode({'items': items, 'version': version});

    // Save to file
    return _fileStorage.writeFile(str).then((_) => {});
  }
}
