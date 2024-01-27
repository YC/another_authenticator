import 'package:another_authenticator_state/state.dart';

class TestFileStorage implements FileStorageBase {
  String? memoryFile;

  @override
  Future<String> getDataPath() {
    return Future.value(".");
  }

  @override
  Future<bool> hasFile(String filename) {
    return Future.value(memoryFile != null);
  }

  @override
  Future<String?> readFile(String filename) {
    return Future.value(memoryFile);
  }

  @override
  Future writeFile(String filename, String contents) {
    memoryFile = contents;
    return Future.value();
  }
}
