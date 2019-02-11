import 'package:collection/collection.dart' show ListEquality;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalMaterialLocalizations, GlobalWidgetsLocalizations;
import 'package:another_authenticator/intl/intl.dart'
    show AppLocalizations, AppLocalizationsDelegate;
import 'package:another_authenticator/state/state.dart'
    show RepositoryBase, Repository, FileStorage, AppState;
import 'package:another_authenticator/totp/totp.dart' show TOTPItem;
import 'package:another_authenticator/ui/adaptive.dart' show getPlatform;
import 'package:another_authenticator/pages/pages.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  // Used to read/save state to disk
  static const STATE_FILENAME = "items.json";
  final RepositoryBase repository =
      new Repository(new FileStorage(STATE_FILENAME));

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  // Stores state of app
  AppState appState;

  @override
  void initState() {
    // Load initial state
    widget.repository.loadState().then((items) {
      super.setState(() {
        appState = AppState(items);
      });
    });
    super.initState();
  }

  // Locale information
  final Iterable<Locale> supportedLocales = [const Locale('en', 'US')];
  final Iterable<LocalizationsDelegate> localizationsDelegates = [
    const AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  @override
  Widget build(BuildContext context) {
    // Platform
    TargetPlatform platform = getPlatform();

    // Material/Cupertino app depending on platform
    if (platform == TargetPlatform.android) {
      // Android (Material Design)
      return MaterialApp(
        title: AppLocalizations.title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) =>
              AndroidHomePage(appState == null ? null : appState.items),
          '/edit': (context) => AndroidEditPage(
              appState == null ? null : List<TOTPItem>.from(appState.items),
              itemsChanged,
              replaceItems),
          '/add': (context) => AddPage(addItem),
          '/add/scan': (context) => ScanQRPage(addItem),
          '/settings': (context) => SettingsPage(),
          '/settings/acknowledgements': (context) => AcknowledgementsPage()
        },
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
      );
    } else if (platform == TargetPlatform.iOS) {
      // iOS (Cupertino)
      return CupertinoApp(
          title: AppLocalizations.title,
          initialRoute: '/',
          routes: {
            '/': (context) =>
                CupertinoHomePage(appState == null ? null : appState.items),
            '/edit': (context) => CupertinoEditPage(
                appState == null ? null : List<TOTPItem>.from(appState.items),
                itemsChanged,
                replaceItems),
            '/add': (context) => AddPage(addItem),
            '/add/scan': (context) => ScanQRPage(addItem),
            '/settings': (context) => SettingsPage(),
            '/settings/acknowledgements': (context) => AcknowledgementsPage()
          },
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales);
    } else {
      throw new Exception("Unrecognised platform");
    }
  }

  // Adds a TOTP item to the list
  void addItem(TOTPItem item) {
    setState(() {
      appState.addItem(item);
    });
    widget.repository.saveState(appState.items);
  }

  // Replace items in state and save
  void replaceItems(List<TOTPItem> items) {
    setState(() {
      appState.replaceItems(items);
    });
    widget.repository.saveState(appState.items);
  }

  // Whether items have changed
  bool itemsChanged(List<TOTPItem> items) {
    return !const ListEquality().equals(appState.items, items);
  }
}
