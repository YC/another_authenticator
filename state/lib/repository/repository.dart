import 'dart:async' show Future;

import '../authenticator_item.dart';
import './repository_base.dart' show RepositoryBase;
import './legacy_repository.dart' show LegacyRepository;

/// Wrapper for repository.
class Repository implements RepositoryBase {
  late RepositoryBase repository;

  Repository(fileStorage) {
    repository = LegacyRepository(fileStorage);
  }

  @override
  Future<bool> hasState() {
    return repository.hasState();
  }

  @override
  Future<List<AuthenticatorItem>> loadItems() async {
    return repository.loadItems();
  }

  @override
  Future saveItems(List<AuthenticatorItem> items) async {
    return repository.saveItems(items);
  }

  @override
  Future<AuthenticatorItem> addItem(AuthenticatorItem item) async {
    return repository.addItem(item);
  }
}
