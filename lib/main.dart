import 'package:another_authenticator/state/file_storage.dart';
import 'package:another_authenticator_state/authenticator_item.dart';
import 'package:collection/collection.dart' show ListEquality;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalMaterialLocalizations, GlobalWidgetsLocalizations;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:another_authenticator_state/state.dart'
    show RepositoryBase, Repository, AppState;
import 'package:another_authenticator/ui/adaptive.dart' show getPlatform;
import 'package:another_authenticator/pages/pages.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  // Used to read/save state to disk
  static const STATE_FILENAME = "items.json";
  final RepositoryBase repository = new Repository(FileStorage(STATE_FILENAME));

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  // Stores state of app
  AppState? appState;

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
  final Iterable<Locale> supportedLocales = [const Locale('en')];
  final Iterable<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizations.delegate,
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
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => AndroidHomePage(appState?.items, addItem),
          '/edit': (context) => AndroidEditPage(
              appState == null
                  ? null
                  : List<AuthenticatorItem>.from(appState!.items),
              itemsChanged,
              replaceItems),
          '/add': (context) => AddPage(addItem),
          '/add/scan': (context) => ScanQRPage(),
          '/settings': (context) => SettingsPage(),
          '/settings/acknowledgements': (context) => AcknowledgementsPage()
        },
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
      );
    } else if (platform == TargetPlatform.iOS) {
      // iOS (Cupertino)
      return CupertinoApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
        initialRoute: '/',
        theme: CupertinoThemeData(brightness: Brightness.light),
        routes: {
          '/': (context) => CupertinoHomePage(appState?.items, addItem),
          '/edit': (context) => CupertinoEditPage(
              appState == null
                  ? null
                  : List<AuthenticatorItem>.from(appState!.items),
              itemsChanged,
              replaceItems),
          '/add': (context) => AddPage(addItem),
          '/add/scan': (context) => ScanQRPage(),
          '/settings': (context) => SettingsPage(),
          '/settings/acknowledgements': (context) => AcknowledgementsPage()
        },
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
      );
    } else {
      throw new Exception("Unrecognised platform");
    }
  }

  // Adds a TOTP item to the list
  void addItem(AuthenticatorItem item) {
    setState(() {
      appState!.addItem(item);
    });
    widget.repository.saveState(appState!.items);
  }

  // Replace items in state and save
  void replaceItems(List<AuthenticatorItem> items) {
    setState(() {
      appState!.replaceItems(items);
    });
    widget.repository.saveState(appState!.items);
  }

  // Whether items have changed
  bool itemsChanged(List<AuthenticatorItem> items) {
    return !const ListEquality().equals(appState!.items, items);
  }
}
