import 'package:another_authenticator/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalMaterialLocalizations, GlobalWidgetsLocalizations;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:another_authenticator/state/file_storage.dart';
import 'package:another_authenticator_state/state.dart' show Repository;
import 'package:another_authenticator/ui/adaptive.dart' show getPlatform;
import 'package:another_authenticator/pages/pages.dart';
import 'package:provider/provider.dart';

void main() {
  var repository = Repository(FileStorage());
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => AppState(repository))],
    child: App(),
  ));
}

class App extends StatelessWidget {
  // Locale information
  final Iterable<Locale> supportedLocales = [const Locale('en')];
  final Iterable<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);

    // Platform
    TargetPlatform platform = getPlatform();

    // Material/Cupertino app depending on platform
    if (platform == TargetPlatform.android) {
      // Android (Material Design)
      return MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => AndroidHomePage(),
          '/edit': (context) => AndroidEditPage(),
          '/add': (context) => AddPage(),
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
          '/': (context) => CupertinoHomePage(),
          '/edit': (context) => CupertinoEditPage(),
          '/add': (context) => AddPage(),
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
}
