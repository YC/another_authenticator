import 'dart:async' show Future;

import '../file_storage_base.dart';
import '../legacy/legacy_authenticator_item.dart';
import './repository_base.dart' show RepositoryBase;
import '../legacy/legacy_repository.dart' show LegacyRepository;

/// Wrapper for repository.
class Repository implements RepositoryBase<LegacyAuthenticatorItem> {
  late RepositoryBase<LegacyAuthenticatorItem> _legacyRepository;
  late FileStorageBase _fileStorage;

  Repository(fileStorage) {
    _legacyRepository = LegacyRepository(fileStorage);
    _fileStorage = fileStorage;
  }

  @override
  Future<List<LegacyAuthenticatorItem>> loadItems() async {
    // Open the database and store the reference.
    // join(await _fileStorage.getDataPath(), 'main.db')
    _fileStorage.getDataPath();

    return _legacyRepository.loadItems();
  }

  @override
  Future replaceItems(List<LegacyAuthenticatorItem> items) async {
    return _legacyRepository.replaceItems(items);
  }

  @override
  Future<LegacyAuthenticatorItem> addItem(LegacyAuthenticatorItem item) async {
    return _legacyRepository.addItem(item);
  }
}
