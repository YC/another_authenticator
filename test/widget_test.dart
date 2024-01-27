// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:another_authenticator/state/app_state.dart';
import 'package:another_authenticator/state/file_storage.dart';
import 'package:another_authenticator/main.dart';
import 'package:another_authenticator_state/state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    var repository = Repository(FileStorage());

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState(repository))
        ],
        child: App(),
      ),
    );
  });
}
