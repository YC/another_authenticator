import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/widgets.dart' show Color;
import 'package:flutter/material.dart' show BuildContext, Theme;
import 'package:flutter/cupertino.dart' show CupertinoTheme;
export './adaptive_dialog.dart';
export './adaptive_textfield.dart';
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

/// Gets scaffold colour of theme.
Color getScaffoldColor(BuildContext context) {
  if (getPlatform() == TargetPlatform.android) {
    return Theme.of(context).scaffoldBackgroundColor;
  } else {
    return CupertinoTheme.of(context).scaffoldBackgroundColor;
  }
}
