import '../ui/adaptive_base.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show AppBar, Scaffold;
import 'package:flutter/cupertino.dart'
    show CupertinoNavigationBar, CupertinoPageScaffold;

/// Basic scaffold for app.
class AppScaffold extends AdaptiveBase<Scaffold, CupertinoPageScaffold> {
  final Widget? title;
  final Widget body;
  final CupertinoNavigationBar? cupertinoNavigationBar;

  /// Creates an adaptive scaffold with given attributes.
  const AppScaffold(
      {this.title, required this.body, this.cupertinoNavigationBar, Key? key})
      : super(key);

  @override
  Scaffold createAndroidWidget(BuildContext context) {
    return Scaffold(appBar: AppBar(title: title), body: body);
  }

  @override
  CupertinoPageScaffold createCupertinoWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:
          cupertinoNavigationBar ?? CupertinoNavigationBar(middle: title),
      child: SafeArea(child: body),
    );
  }
}
