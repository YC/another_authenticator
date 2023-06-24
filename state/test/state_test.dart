import 'package:another_authenticator_state/app_state.dart';
import 'package:another_authenticator_state/authenticator_item.dart';
import 'package:another_authenticator_totp/totp_item.dart';
import 'package:test/test.dart';

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
