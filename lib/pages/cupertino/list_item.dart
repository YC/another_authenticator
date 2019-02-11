// Overlay adapted from:
// https://www.didierboelens.com/2018/06/how-to-create-a-toast-or-notifications-notion-of-overlay/

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/material.dart' show CircularProgressIndicator;
import 'package:another_authenticator/totp/totp.dart' show TOTPItem;
import '../shared/list_item_base.dart' show TOTPListItemBase;

/// Home page list item (Cupertino).
class HomeListItem extends TOTPListItemBase {
  HomeListItem(TOTPItem item, {Key key}) : super(item, key: key);

  @override
  State<StatefulWidget> createState() => _TOTPListItemState();
}

class _TOTPListItemState extends State<HomeListItem>
    with SingleTickerProviderStateMixin {
  // Dimension of progress indicator
  static const double _PROGRESS_INDICATOR_DIMENSION = 25;

  // Animation for indicator/code
  AnimationController _controller;
  Animation<double> _animation;

  // Code that is being displayed
  String _code;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Set initial code
    setState(() {
      _code = widget.code;
    });

    // Define animation
    // Adapted from progress_indicator_demo.dart from flutter examples
    _controller = AnimationController(
      duration: Duration(seconds: widget.item.period),
      lowerBound: 0.0,
      upperBound: 1.0,
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
    _controller.forward(from: widget.indicatorValue);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          // Set code
          setState(() {
            _code = widget.code;
          });
          // Reset animation
          _controller.forward(from: widget.indicatorValue);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: widget.item.id,
        child: GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.codeUnformatted));
            },
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(color: CupertinoColors.white),
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(5),
                    child: Stack(
                      children: <Widget>[
                        Column(
                            // Align to start (left)
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Issuer
                              Text(widget.item.issuer),
                              // Generated code
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(_code,
                                      style: const TextStyle(
                                          fontSize: 40,
                                          color: Color.fromARGB(
                                              255, 125, 125, 125)))),
                              // Account name
                              Text(widget.item.accountName,
                                  style: const TextStyle(fontSize: 13))
                            ]),
                        Positioned(
                            child: AnimatedBuilder(
                                animation: _animation,
                                builder: (BuildContext context, Widget child) =>
                                    CircularProgressIndicator(
                                      value: _animation.value,
                                      strokeWidth: 2.5,
                                    )),
                            right: 0,
                            bottom: 0,
                            height: _PROGRESS_INDICATOR_DIMENSION,
                            width: _PROGRESS_INDICATOR_DIMENSION)
                      ],
                    )))));
  }
}
