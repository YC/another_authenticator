import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show AppBar, Scaffold;
import 'package:flutter/cupertino.dart'
    show CupertinoNavigationBar, CupertinoPageScaffold;
import './adaptive.dart';

/// Basic scaffold for app.
class AppScaffold extends StatelessWidget {
  final Key key;
  final Widget title;
  final Widget body;
  final CupertinoNavigationBar cupertinoNavigationBar;

  /// Creates an adaptive scaffold with given attributes.
  AppScaffold({this.key, this.title, this.body, this.cupertinoNavigationBar});

  @override
  Widget build(BuildContext context) {
    if (getPlatform() == TargetPlatform.android) {
      return Scaffold(appBar: AppBar(title: title), body: body);
    } else {
      return CupertinoPageScaffold(
          navigationBar:
              cupertinoNavigationBar ?? CupertinoNavigationBar(middle: title),
          child: SafeArea(child: body));
    }
  }
}
