import 'state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalMaterialLocalizations, GlobalWidgetsLocalizations;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'state/file_storage.dart';
import 'package:another_authenticator_state/state.dart' show Repository;
import 'ui/adaptive.dart' show getPlatform;
import 'pages/pages.dart';
import 'package:provider/provider.dart';

import 'config/routes.dart';

void main() {
  var repository = Repository(FileStorage());
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => AppState(repository))],
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  // Locale information
  final Iterable<Locale> supportedLocales = [const Locale('en')];
  final Iterable<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);

    // Platform
    TargetPlatform platform = getPlatform();

    // Material/Cupertino app depending on platform
    return platform == TargetPlatform.iOS
        ? CupertinoApp(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
            initialRoute: AppRoutes.home,
            theme: const CupertinoThemeData(brightness: Brightness.light),
            routes: {
              AppRoutes.home: (context) => const CupertinoHomePage(),
              AppRoutes.edit: (context) => const CupertinoEditPage(),
              AppRoutes.add: (context) => const AddPage(),
              AppRoutes.addScan: (context) => const ScanQRPage(),
              AppRoutes.settings: (context) => const SettingsPage(),
              AppRoutes.settingAcknowledgements: (context) =>
                  const AcknowledgementsPage()
            },
            localizationsDelegates: localizationsDelegates,
            supportedLocales: supportedLocales,
          )
        : MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.system,
            initialRoute: AppRoutes.home,
            routes: {
              AppRoutes.home: (context) => const AndroidHomePage(),
              AppRoutes.edit: (context) => const AndroidEditPage(),
              AppRoutes.add: (context) => const AddPage(),
              AppRoutes.addScan: (context) => const ScanQRPage(),
              AppRoutes.settings: (context) => const SettingsPage(),
              AppRoutes.settingAcknowledgements: (context) =>
                  const AcknowledgementsPage()
            },
            localizationsDelegates: localizationsDelegates,
            supportedLocales: supportedLocales,
          );
  }
}
