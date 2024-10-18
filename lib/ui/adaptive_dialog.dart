// Adaptive Dialog
// Adapted from flutter/flutter, using FlatButton, CupertinoDialogAction
// showDialog, showCupertinoDialog
//
// Licensed under:
// https://raw.githubusercontent.com/flutter/flutter/master/LICENSE

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './adaptive_base.dart' show AdaptiveBase;

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

  const AdaptiveDialogAction(
      {this.androidData,
      this.cupertinoData,
      required this.onPressed,
      required this.child,
      Key? key})
      : super(key);

  @override
  TextButton createAndroidWidget(BuildContext context) {
    return TextButton(
      key: androidData?.key,
      onPressed: androidData?.onPressed ?? onPressed,
      child: androidData?.child ?? child,
    );
  }

  @override
  CupertinoDialogAction createCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      key: androidData?.key,
      onPressed: cupertinoData?.onPressed ?? onPressed,
      child: cupertinoData?.child ?? child,
    );
  }
}
