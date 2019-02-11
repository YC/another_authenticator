import 'dart:async' show Future;
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

/// Loads/stores file to application storage directory
///
/// From:
/// * https://flutter.io/docs/cookbook/persistence/reading-writing-files
class FileStorage {
  /// Instantiates instance of FileStorage with given file name.
  FileStorage(this._filename);

  /// Name of file to store.
  final String _filename;

  /// Gets path of application storage directory.
  static Future<String> get _path async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Gets stored file.
  Future<File> get _file async {
    var path = await _path;
    return File('$path/$_filename');
  }

  /// Returns boolean value indicating whether file exists.
  Future<bool> fileExists() async {
    final file = await _file;
    return file.exists();
  }

  /// Reads from file into String.
  Future<String> readFile() async {
    final file = await _file;
    return file.readAsString();
  }

  /// Writes to file.
  Future<File> writeFile(String contents) async {
    final file = await _file;
    return file.writeAsString(contents);
  }
}
