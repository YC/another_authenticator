import 'dart:async' show Future;
import 'package:package_info/package_info.dart' show PackageInfo;

/// Used to access information about app.
///
/// Wrapper class for package_info.
class AppInfo {
  final String _appName;
  final String _packageName;
  final String _version;
  final String _buildNumber;

  /// App name
  String get appName => this._appName;

  /// Package name
  String get packageName => this._packageName;

  /// Version
  String get version => this._version;

  /// Build number
  String get buildNumber => this._buildNumber;

  AppInfo._(this._appName, this._packageName, this._version, this._buildNumber);

  // Instance of AppInfo class
  static AppInfo _appInfo;

  /// Get instance of AppInfo class as Future.
  static Future<AppInfo> getAppInfo() async {
    if (_appInfo != null) {
      return Future.value(_appInfo);
    }

    var packageInfo = await PackageInfo.fromPlatform();
    _appInfo = AppInfo._(packageInfo.appName, packageInfo.packageName,
        packageInfo.version, packageInfo.buildNumber);
    return Future.value(_appInfo);
  }
}
