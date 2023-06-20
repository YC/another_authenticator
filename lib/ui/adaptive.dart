import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
export './adaptive_dialog.dart';
export './app_scaffold.dart';

/// Gets platform.
TargetPlatform getPlatform() {
  TargetPlatform result = defaultTargetPlatform;
  // result = TargetPlatform.iOS;
  return result;
}

/// Whether the current platform is Android.
bool isPlatformAndroid() {
  return getPlatform() == TargetPlatform.android;
}
