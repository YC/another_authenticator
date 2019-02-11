import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:another_authenticator/totp/totp.dart' show TOTPItem;
import 'package:another_authenticator/intl/intl.dart' show AppLocalizations;
import '../shared/list_item_base.dart' show TOTPListItemBase;

/// Home page list item (Android).
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
        child: Card(
            child: InkWell(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: widget.codeUnformatted));
                  Scaffold.of(context).removeCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(AppLocalizations.of(context).clipboard),
                      duration: const Duration(seconds: 1)));
                },
                child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.all(5),
                        child: Stack(
                          children: <Widget>[
                            Column(
                                // Align to start (left)
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // Issuer
                                  Text(widget.item.issuer,
                                      style:
                                          Theme.of(context).textTheme.subhead),
                                  // Generated code
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(_code,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2)),
                                  // Account name
                                  Text(widget.item.accountName,
                                      style: Theme.of(context).textTheme.body1)
                                ]),
                            Positioned(
                                child: AnimatedBuilder(
                                    animation: _animation,
                                    builder:
                                        (BuildContext context, Widget child) =>
                                            CircularProgressIndicator(
                                              value: _animation.value,
                                              strokeWidth: 2.5,
                                            )),
                                right: 0,
                                bottom: 0,
                                height: _PROGRESS_INDICATOR_DIMENSION,
                                width: _PROGRESS_INDICATOR_DIMENSION)
                          ],
                        ))))));
  }
}
