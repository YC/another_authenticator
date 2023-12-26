import 'dart:async' show Future;
import 'dart:io' show File;
import 'package:another_authenticator_state/file_storage_base.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

/// Loads/stores file to application storage directory
///
/// From:
/// * https://flutter.io/docs/cookbook/persistence/reading-writing-files
class FileStorage extends FileStorageBase {
  /// Instantiates instance of FileStorage
  FileStorage();

  /// Gets path of Application Documents Directory.
  Future<String> getDataPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _filePath(String filename) async {
    var path = await getDataPath();
    return File('$path/$filename');
  }

  /// Whether file is present.
  @override
  Future<bool> hasFile(String filename) async {
    final file = await _filePath(filename);
    return file.exists();
  }

  /// Reads from file into String.
  @override
  Future<String?> readFile(String filename) async {
    final file = await _filePath(filename);
    if (!await file.exists()) {
      return null;
    }
    return file.readAsString();
  }

  /// Writes to file.
  @override
  Future writeFile(String filename, String contents) async {
    final file = await _filePath(filename);
    await file.writeAsString(contents, flush: true);
  }
}
