import 'package:flutter_test/flutter_test.dart';
import 'package:another_authenticator/state/app_state.dart';
import 'package:another_authenticator/totp/totp_item.dart';

void main() {
  test('Init/get empty state', () {
    AppState state = AppState([]);
    expect(state.items.length, 0);
  });

  test('Init/get non-empty state', () {
    var item = TOTPItem("id", "A");
    AppState state = AppState([item]);
    expect(state.items.length, 1);
    expect(state.items[0], item);
  });

  test('Add item to state', () {
    AppState state = AppState([]);
    var item = TOTPItem("id", "A");
    state.addItem(item);
    expect(state.items.length, 1);
    expect(state.items[0], item);
  });

  test('Remove item from state', () {
    var item = TOTPItem("id", "A");
    AppState state = AppState([item]);
    state.removeItem(item);
    expect(state.items.length, 0);
  });

  test('Replace item', () {
    var oldItem = TOTPItem("id", "A");
    var newItem = TOTPItem("id2", "B");
    AppState state = AppState([oldItem]);
    state.replaceItem(oldItem, newItem);
    expect(state.items.length, 1);
    expect(state.items[0], newItem);
  });

  test('Replace items', () {
    var oldItems = [TOTPItem("id", "A")];
    var newItems = [TOTPItem("id2", "B")];
    AppState state = AppState(oldItems);
    state.replaceItems(newItems);
    expect(state.items.length, 1);
    expect(state.items[0], newItems[0]);
  });
}
