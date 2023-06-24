abstract class FileStorageBase {
  /// Returns boolean value indicating whether file exists.
  Future<bool> fileExists();

  /// Reads from file into String.
  Future<String> readFile();

  /// Writes to file.
  Future writeFile(String contents);
}
