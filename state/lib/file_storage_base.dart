abstract class FileStorageBase {
  /// Get path to store persistent data.
  Future<String> getDataPath();

  /// Does file exist?
  Future<bool> hasFile(String filename);

  /// Reads from file into String.
  Future<String?> readFile(String filename);

  /// Writes to file.
  Future writeFile(String filename, String contents);
}
