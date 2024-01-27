import 'package:another_authenticator_state/state.dart';
import 'package:flutter/widgets.dart';

/// Abstract base class for TOTP list item.
///
/// Contains useful methods which are used to display the item.
abstract class TOTPListItemBase extends StatefulWidget {
  TOTPListItemBase(this.item, {Key? key});

  /// The item/account that is displayed.
  final LegacyAuthenticatorItem item;

  /// Seconds since epoch.
  static int get _secondsSinceEpoch {
    return new DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  /// Progress indicator value.
  double get indicatorValue {
    return (_secondsSinceEpoch % item.totp.period) / item.totp.period;
  }

  /// Returns the code of the item for the current time.
  String get codeUnformatted {
    return item.totp.getCode(_secondsSinceEpoch);
  }

  /// Returns the code of the item for the current time in formatted form.
  String get code {
    return item.totp.getPrettyCode(_secondsSinceEpoch);
  }

  @override
  State<StatefulWidget> createState();
}
