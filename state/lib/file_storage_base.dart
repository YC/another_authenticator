import 'dart:io';

abstract class FileStorageBase {
  /// Returns boolean value indicating whether file exists.
  Future<bool> fileExists();

  /// Reads from file into String.
  Future<String> readFile();

  /// Writes to file.
  Future<File> writeFile(String contents);
}
