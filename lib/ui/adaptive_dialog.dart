/// Adaptive Dialog
/// Adapted from flutter/flutter, using FlatButton, CupertinoDialogAction
/// showDialog, showCupertinoDialog
///
/// Licensed under:
/// https://raw.githubusercontent.com/flutter/flutter/master/LICENSE

import 'dart:async' show Future;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './adaptive_base.dart' show AdaptiveBase;
import './adaptive.dart' show getPlatform;

class AdaptiveAndroidDialogActionData {
  final Key key;
  final VoidCallback onPressed;
  final ValueChanged<bool> onHighlightChanged;
  final ButtonTextTheme textTheme;
  final Color textColor;
  final Color disabledTextColor;
  final Color color;
  final Color disabledColor;
  final Color highlightColor;
  final Color splashColor;
  final Brightness colorBrightness;
  final EdgeInsetsGeometry padding;
  final ShapeBorder shape;
  final Clip clipBehavior;
  final MaterialTapTargetSize materialTapTargetSize;
  final Widget child;

  AdaptiveAndroidDialogActionData(
      {this.key,
      @required this.onPressed,
      this.onHighlightChanged,
      this.textTheme,
      this.textColor,
      this.disabledTextColor,
      this.color,
      this.disabledColor,
      this.highlightColor,
      this.splashColor,
      this.colorBrightness,
      this.padding,
      this.shape,
      this.clipBehavior,
      this.materialTapTargetSize,
      @required this.child});
}

class AdaptiveCupertinoDialogActionData {
  final VoidCallback onPressed;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final TextStyle textStyle;
  final Widget child;

  AdaptiveCupertinoDialogActionData(
      {this.onPressed,
      this.isDefaultAction,
      this.isDestructiveAction,
      this.textStyle,
      @required this.child});
}

class AdaptiveDialogAction
    extends AdaptiveBase<FlatButton, CupertinoDialogAction> {
  final AdaptiveAndroidDialogActionData androidData;
  final AdaptiveCupertinoDialogActionData cupertinoData;
  final VoidCallback onPressed;
  final Widget child;

  AdaptiveDialogAction(
      {this.androidData,
      this.cupertinoData,
      @required this.onPressed,
      @required this.child});

  FlatButton createAndroidWidget(BuildContext context) {
    return FlatButton(
      key: androidData?.key,
      onPressed: androidData?.onPressed ?? onPressed,
      onHighlightChanged: androidData?.onHighlightChanged,
      textTheme: androidData?.textTheme,
      textColor: androidData?.textColor,
      disabledTextColor: androidData?.disabledTextColor,
      color: androidData?.color,
      disabledColor: androidData?.disabledColor,
      highlightColor: androidData?.highlightColor,
      splashColor: androidData?.splashColor,
      colorBrightness: androidData?.colorBrightness,
      padding: androidData?.padding,
      shape: androidData?.shape,
      clipBehavior: androidData?.clipBehavior ?? Clip.none,
      materialTapTargetSize: androidData?.materialTapTargetSize,
      child: androidData?.child ?? child,
    );
  }

  CupertinoDialogAction createCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      onPressed: cupertinoData?.onPressed ?? onPressed,
      isDefaultAction: cupertinoData?.isDefaultAction ?? false,
      isDestructiveAction: cupertinoData?.isDestructiveAction ?? false,
      textStyle: cupertinoData?.textStyle,
      child: cupertinoData?.child ?? child,
    );
  }
}

/// Android alert dialog data
class AdaptiveAndroidAlertDialogData {
  final Key key;
  final Widget title;
  final EdgeInsetsGeometry titlePadding;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;
  final List<Widget> actions;
  final String semanticLabel;
  final ShapeBorder shape;

  AdaptiveAndroidAlertDialogData(
      {this.key,
      this.title,
      this.titlePadding,
      this.content,
      this.contentPadding,
      this.actions,
      this.semanticLabel,
      this.shape});
}

/// Cupertino alert dialog data
class AdaptiveCupertinoAlertDialogData {
  final Key key;
  final Widget title;
  final Widget content;
  final List<Widget> actions;
  final ScrollController scrollController;
  final ScrollController actionScrollController;

  AdaptiveCupertinoAlertDialogData(
      {this.key,
      this.title,
      this.content,
      this.actions,
      this.scrollController,
      this.actionScrollController});
}

Future<T> showAdaptiveDialog<T>(BuildContext context,
    {Key key,
    Widget title,
    Widget content,
    List<Widget> actions,
    AdaptiveAndroidAlertDialogData androidData,
    AdaptiveCupertinoAlertDialogData cupertinoData}) {
  var platform = getPlatform();
  if (platform == TargetPlatform.android) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              key: key ?? androidData?.key,
              title: title ?? androidData?.title,
              titlePadding: androidData?.titlePadding,
              content: content ?? androidData?.content,
              contentPadding: androidData?.contentPadding ??
                  const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
              actions: actions ?? androidData?.actions,
              semanticLabel: androidData?.semanticLabel,
              shape: androidData?.shape);
        });
  } else {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              key: key ?? cupertinoData?.key,
              title: title ?? cupertinoData?.title,
              content: content ?? cupertinoData?.content,
              actions: actions ?? cupertinoData?.actions,
              scrollController: cupertinoData?.scrollController,
              actionScrollController: cupertinoData?.actionScrollController);
        });
  }
}
