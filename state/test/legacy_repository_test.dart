import 'package:another_authenticator_state/legacy/legacy_repository.dart';
import 'package:another_authenticator_state/state.dart';
import 'package:another_authenticator_totp/totp.dart';
import 'package:test/test.dart';

import 'test_file_storage.dart';

void main() {
  test('Has State?', () async {
    var repository = LegacyRepository(TestFileStorage());
    expect(await repository.hasState(), false);
  });

  test('Load', () async {
    var repository = LegacyRepository(TestFileStorage());
    var items = await repository.loadItems();
    expect(items.length, 0);
  });

  test('Add Item', () async {
    var repository = LegacyRepository(TestFileStorage());
    var item = TotpItem("ABCDEF");
    await repository.addItem(item);

    var items = await repository.loadItems();
    expect(items.length, 1);
    expect(items[0].totp, item);
  });

  test('Replace items', () async {
    var repository = LegacyRepository(TestFileStorage());
    var item = TotpItem("A");
    await repository.addItem(item);

    var item2 = LegacyAuthenticatorItem("id", TotpItem("A"));
    await repository.replaceItems([item2]);

    var newItems = await repository.loadItems();
    expect(newItems.length, 1);
    expect(newItems[0], item2);
  });
}
