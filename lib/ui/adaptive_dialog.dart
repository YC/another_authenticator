/// Adaptive Dialog
/// Adapted from flutter/flutter, using FlatButton, CupertinoDialogAction
/// showDialog, showCupertinoDialog
///
/// Licensed under:
/// https://raw.githubusercontent.com/flutter/flutter/master/LICENSE

import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './adaptive_base.dart' show AdaptiveBase;
import './adaptive.dart' show getPlatform;

class AdaptiveAndroidDialogActionData {
  final Key? key;
  final VoidCallback? onPressed;
  final Widget? child;

  AdaptiveAndroidDialogActionData(
      {this.key, @required this.onPressed, @required this.child});
}

class AdaptiveCupertinoDialogActionData {
  final Key? key;
  final VoidCallback? onPressed;
  final Widget? child;

  AdaptiveCupertinoDialogActionData(
      {this.key, this.onPressed, @required this.child});
}

class AdaptiveDialogAction
    extends AdaptiveBase<TextButton, CupertinoDialogAction> {
  final AdaptiveAndroidDialogActionData? androidData;
  final AdaptiveCupertinoDialogActionData? cupertinoData;
  final VoidCallback onPressed;
  final Widget child;

  AdaptiveDialogAction(
      {this.androidData,
      this.cupertinoData,
      required this.onPressed,
      required this.child});

  TextButton createAndroidWidget(BuildContext context) {
    return TextButton(
      key: androidData?.key,
      onPressed: androidData?.onPressed ?? onPressed,
      child: androidData?.child ?? child,
    );
  }

  CupertinoDialogAction createCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      key: androidData?.key,
      onPressed: cupertinoData?.onPressed ?? onPressed,
      child: cupertinoData?.child ?? child,
    );
  }
}

/// Android alert dialog data
class AdaptiveAndroidAlertDialogData {
  final Key? key;
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  AdaptiveAndroidAlertDialogData(
      {this.key, this.title, this.content, this.actions});
}

/// Cupertino alert dialog data
class AdaptiveCupertinoAlertDialogData {
  final Key? key;
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  AdaptiveCupertinoAlertDialogData(
      {this.key, this.title, this.content, this.actions});
}

Future<dynamic> showAdaptiveDialog<T>(BuildContext context,
    {Key? key,
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    AdaptiveAndroidAlertDialogData? androidData,
    AdaptiveCupertinoAlertDialogData? cupertinoData}) {
  var platform = getPlatform();
  if (platform == TargetPlatform.android) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          key: key ?? androidData?.key,
          title: title ?? androidData?.title,
          content: content ?? androidData?.content,
          actions: actions ?? androidData?.actions ?? [],
        );
      },
    );
  } else {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          key: key ?? cupertinoData?.key,
          title: title ?? cupertinoData?.title,
          content: content ?? cupertinoData?.content,
          actions: actions ?? cupertinoData?.actions ?? [],
        );
      },
    );
  }
}
