// Localization
// https://flutter.io/docs/development/accessibility-and-localization/internationalization

import 'dart:async' show Future;
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/widgets.dart'
    show Locale, BuildContext, Localizations, LocalizationsDelegate;

class AppLocalizations {
  AppLocalizations(this._locale);

  /// App title
  static const String title = "Another Authenticator";

  /// Repo URL
  static const String repo = "https://github.com/YC/another_authenticator";

  final Locale _locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Supported locales
  static List<String> get supportedLocales => _localizedValues.keys.toList();

  // Values of all locales
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': title,
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'error': 'Error',
      'save': 'Save',
      'edit': 'Edit',
      'add': 'Add',
      'addTitle': 'Add Account',
      'addScanQR': 'Scan QR Code',
      'addManualInput': 'Manual Input',
      'addMethodPrompt': 'Please select input method.',
      'cancel': 'Cancel',
      'secret': 'Secret key',
      'secretInvalidMessage': 'Secret key is invalid',
      'issuer': 'Provider/Issuer',
      'accountName': 'Account Name',
      'digits': 'Number of digits',
      'period': 'Time step',
      'settingsTitle': 'Settings',
      'source': 'Source code',
      'licenses': 'Acknowledgments',
      'clipboard': 'Copied to clipboard',
      'noAccounts': 'You have no accounts,\n press the + button to add one.',
      'loading': 'Loading...',
      'editTitle': 'Edit Accounts',
      'removeAccounts': 'Remove accounts',
      'removeConfirmation':
          'Please do not forget to turn off 2 factor authentication before removal.\n\n' +
              'Are you sure that you want to remove the selected account(s)?',
      'exitEditTitle': 'Exit',
      'exitEditInfo': 'Do you want to exit edit mode without saving?',
      'DUPLICATE_ACCOUNT': 'Duplicate account',
      'ID_COLLISION': 'A rare ID collision has occurred. Please try again.',
      'errNoCameraPermission': 'Camera permission not granted',
      'errIncorrectFormat': 'Scanned code is of incorrect format',
      'errUnknown': 'Unknown error'
    }
  };

  // Values of current locale
  Map<String, String> get _values => _localizedValues[_locale.languageCode];

  String get appName => _values['appName'];
  String get ok => _values['ok'];
  String get yes => _values['yes'];
  String get no => _values['no'];
  String get error => _values['error'];
  String get save => _values['save'];
  String get edit => _values['edit'];
  String get add => _values['add'];
  String get addTitle => _values['addTitle'];
  String get addScanQR => _values['addScanQR'];
  String get addManualInput => _values['addManualInput'];
  String get addMethodPrompt => _values['addMethodPrompt'];
  String get cancel => _values['cancel'];
  String get secret => _values['secret'];
  String get secretInvalidMessage => _values['secretInvalidMessage'];
  String get issuer => _values['issuer'];
  String get accountName => _values['accountName'];
  String get digits => _values['digits'];
  String get period => _values['period'];
  String get settingsTitle => _values['settingsTitle'];
  String get sourceCode => _values['source'];
  String get licenses => _values['licenses'];
  String get clipboard => _values['clipboard'];
  String get loading => _values['loading'];
  String get noAccounts => _values['noAccounts'];
  String get editTitle => _values['editTitle'];
  String get removeAccounts => _values['removeAccounts'];
  String get removalConfirmation => _values['removeConfirmation'];
  String get exitEditTitle => _values['exitEditTitle'];
  String get exitEditInfo => _values['exitEditInfo'];
  String get errNoCameraPermission => _values['errNoCameraPermission'];
  String get errIncorrectFormat => _values['errIncorrectFormat'];
  String get errUnknown => _values['errUnknown'];

  /// Returns errorMessage for specified error code.
  ///
  /// Returns original message if code is not found.
  String getErrorMessage(String code) {
    if (_values.containsKey(code)) {
      return _values[code];
    } else {
      return code;
    }
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
