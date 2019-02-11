// Adaptive Widget Base
// Adapted from: https://github.com/aqwert/flutter_platform_widgets

import 'package:flutter/widgets.dart';
import './adaptive.dart' show getPlatform;

/// Abstract class for adaptive widgets.
///
/// Internally, the class splits build into createAndroidWidget and
/// createCupertinoWidget and call the relevant method.
abstract class AdaptiveBase<AWidget extends Widget, CWidget extends Widget>
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (getPlatform() == TargetPlatform.android) {
      return createAndroidWidget(context);
    } else {
      return createCupertinoWidget(context);
    }
  }

  AWidget createAndroidWidget(BuildContext context);
  CWidget createCupertinoWidget(BuildContext context);
}
