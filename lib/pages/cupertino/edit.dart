import 'dart:async' show Future;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ReorderableListView, Icons;
import 'package:another_authenticator/totp/totp.dart' show TOTPItem;
import 'package:another_authenticator/intl/intl.dart' show AppLocalizations;
import './edit_list_item.dart' show EditListItem;

/// Cupertino edit page.
class CupertinoEditPage extends StatefulWidget {
  CupertinoEditPage(this.items, this._itemsChanged, this.replaceItems,
      {Key key})
      : super(key: key);

  final Function replaceItems;
  final Function _itemsChanged;
  final List<TOTPItem> items;

  // Remove items with given ids
  void removeItems(List<String> itemIDs) {
    items.removeWhere((item) => itemIDs.contains(item.id));
  }

  // Whether items have changed
  bool get itemsChanged {
    return _itemsChanged(items);
  }

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<CupertinoEditPage> {
  // Handles reorder of elements
  void _handleReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      widget.items.insert(newIndex, widget.items.removeAt(oldIndex));
      _refreshHide();
    });
  }

  // Whether to hide trash icon
  ValueNotifier<bool> _hideTrash = ValueNotifier(true);
  // Whether to hide save icon
  ValueNotifier<bool> _hideSave = ValueNotifier(true);

  // List of selected items (to be removed)
  final List<String> _pendingRemovalList = List<String>();

  // Handles item check
  void addRemovalItem(String id) {
    _pendingRemovalList.add(id);
    _refreshHide();
  }

  // Handles item uncheck
  void removeRemovalItem(String id) {
    _pendingRemovalList.remove(id);
    _refreshHide();
  }

  // Refreshes value of _hide
  void _refreshHide() {
    _hideTrash.value = _pendingRemovalList.length == 0;
    _hideSave.value = !widget.itemsChanged;
  }

  // Item remove dialog
  void showRemoveDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text(AppLocalizations.of(context).removeAccounts),
              content: Text(AppLocalizations.of(context).removalConfirmation),
              actions: [
                CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoDialogAction(
                  child: Text(AppLocalizations.of(context).ok),
                  onPressed: () {
                    setState(() {
                      widget.removeItems(_pendingRemovalList);
                      _pendingRemovalList.clear();
                      _refreshHide();
                    });
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  // Handle history pop (back button)
  Future<bool> _popCallback() async {
    if (!widget.itemsChanged) {
      return true;
    }
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text(AppLocalizations.of(context).exitEditTitle),
              content: Text(AppLocalizations.of(context).exitEditInfo),
              actions: [
                CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoDialogAction(
                  child: Text(AppLocalizations.of(context).ok),
                  onPressed: () {
                    Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  },
                )
              ]);
        });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // Handle back button
        onWillPop: _popCallback,
        child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                middle: Text(AppLocalizations.of(context).editTitle),
                trailing:
                    Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  // Trash Icon
                  ValueListenableBuilder<bool>(
                      valueListenable: _hideTrash,
                      builder: (context, value, child) {
                        if (value) {
                          return Container();
                        } else {
                          return CupertinoButton(
                              padding: const EdgeInsets.all(0),
                              child: const Icon(CupertinoIcons.delete),
                              onPressed: () => showRemoveDialog(context));
                        }
                      }),
                  ValueListenableBuilder<bool>(
                      valueListenable: _hideSave,
                      builder: (context, value, child) {
                        if (value) {
                          return Container();
                        } else {
                          return CupertinoButton(
                              padding: const EdgeInsets.all(0),
                              child: const Icon(Icons.check),
                              onPressed: () {
                                widget.replaceItems(widget.items);
                                Navigator.pop(context);
                              });
                        }
                      })
                ])),
            child: widget.items == null
                ? Center(child: Text(AppLocalizations.of(context).loading))
                : SafeArea(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        color: CupertinoTheme.of(context).brightness ==
                                Brightness.light
                            ? CupertinoColors.extraLightBackgroundGray
                            : CupertinoColors.darkBackgroundGray,
                        child: ReorderableListView(
                            scrollDirection: Axis.vertical,
                            children: widget.items
                                .map((item) => EditListItem(
                                    item, addRemovalItem, removeRemovalItem,
                                    key: Key(item.id)))
                                .toList(),
                            onReorder: _handleReorder)))));
  }
}
