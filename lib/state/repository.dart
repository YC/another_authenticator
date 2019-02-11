import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:another_authenticator/state/repository_base.dart'
    show RepositoryBase;
import 'package:another_authenticator/state/file_storage.dart' show FileStorage;
import 'package:another_authenticator/totp/totp.dart' show TOTPItem;

/// Is used to load/save state.
///
/// Currently uses FileStorage to do so.
class Repository implements RepositoryBase {
  Repository(this._fileStorage);

  // Used for loading/saving files
  final FileStorage _fileStorage;

  // Current file version
  static const _CURRENT_VERSION = 1;

  /// Loads state from storage.
  Future<List<TOTPItem>> loadState() async {
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
    if (version != _CURRENT_VERSION) {
      throw new Exception("Unknown file version");
    }

    // Decode and return items
    // Adapted from: https://stackoverflow.com/questions/50360443
    var items = decoded['items'];
    return (items as List).map((i) => TOTPItem.fromJSON(i)).toList();
  }

  /// Saves [state] to storage.
  Future saveState(List<TOTPItem> state) {
    // Encode
    var items = state.map((i) => i.toJSON()).toList();
    var version = _CURRENT_VERSION;
    var str = json.encode({'items': items, 'version': version});

    // Save to file
    return _fileStorage.writeFile(str).then((f) => {});
  }
}
