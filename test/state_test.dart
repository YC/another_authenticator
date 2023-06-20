import 'package:another_authenticator/state/authenticator_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:another_authenticator/state/app_state.dart';
import 'package:another_authenticator_totp/totp.dart' show TotpItem;

void main() {
  test('Init/get empty state', () {
    AppState state = AppState([]);
    expect(state.items.length, 0);
  });

  test('Init/get non-empty state', () {
    var item = AuthenticatorItem("id", TotpItem("A"));
    AppState state = AppState([item]);
    expect(state.items.length, 1);
    expect(state.items[0], item);
  });

  test('Add item to state', () {
    AppState state = AppState([]);
    var item = AuthenticatorItem("id", TotpItem("A"));
    state.addItem(item);
    expect(state.items.length, 1);
    expect(state.items[0], item);
  });

  test('Remove item from state', () {
    var item = AuthenticatorItem("id", TotpItem("A"));
    AppState state = AppState([item]);
    state.removeItem(item);
    expect(state.items.length, 0);
  });

  test('Replace item', () {
    var oldItem = AuthenticatorItem("id", TotpItem("A"));
    var newItem = AuthenticatorItem("id2", TotpItem("B"));
    AppState state = AppState([oldItem]);
    state.replaceItem(oldItem, newItem);
    expect(state.items.length, 1);
    expect(state.items[0], newItem);
  });

  test('Replace items', () {
    var oldItems = [AuthenticatorItem("id", TotpItem("A"))];
    var newItems = [AuthenticatorItem("id2", TotpItem("B"))];
    AppState state = AppState(oldItems);
    state.replaceItems(newItems);
    expect(state.items.length, 1);
    expect(state.items[0], newItems[0]);
  });
}
