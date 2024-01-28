import 'dart:async' show Future;

/// Abstract class for loading/saving state from storage.
abstract class RepositoryBase<T> {
  /// Load list of items from repository.
  Future<List<T>> loadItems();

  /// Replace list of items.
  Future replaceItems(List<T> state);

  /// Add an item to the list.
  Future<T> addItem(T item);
}
