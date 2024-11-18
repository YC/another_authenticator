// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:another_authenticator/pages/acknowledgements.dart';
import 'package:another_authenticator/state/app_state.dart';
import 'package:another_authenticator/state/file_storage.dart';
import 'package:another_authenticator/main.dart';
import 'package:another_authenticator_state/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalMaterialLocalizations, GlobalWidgetsLocalizations;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    var repository = Repository(FileStorage());

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState(repository))
        ],
        child: MainApp(),
      ),
    );
  });

  testWidgets('Acknowledgements page', (WidgetTester tester) async {
    for (var i = 0; i < 100; i++) {
      LicenseRegistry.addLicense(
        () => Stream<LicenseEntry>.value(
            LicenseEntryWithLineBreaks(<String>['test$i'], '''
TestLicense $i
  fff
''')),
      );
    }

    await tester.pumpWidget(
      MaterialApp(
          home: Localizations(
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: const Locale('en'),
        child: const AcknowledgementsPage(),
      )),
    );

    await tester.pumpAndSettle();

    final titleFinder = find.text("Acknowledgements");
    expect(titleFinder, findsOneWidget);

    final scrollFinder = find.byType(Scrollable);
    expect(scrollFinder, findsOneWidget);

    // Scroll to end (hopefully)
    final listTilesFinder = find.byType(ListTile);
    expect(listTilesFinder, findsAny);
    await tester.drag(find.byType(ListTile).first, const Offset(0, -10000));
    await tester.pumpAndSettle();

    final finalItem = find.text("test99");
    expect(finalItem, findsOne);

    await tester.tap(finalItem);
    await tester.pumpAndSettle();

    // Page for individual license
    final subpageTitleFinder = find.text("test99");
    expect(subpageTitleFinder, findsOne);

    final subpageTextFinder = find.text("TestLicense 99");
    expect(subpageTextFinder, findsOne);
  });
}
