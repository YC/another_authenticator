import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:another_authenticator/totp/totp.dart' show TOTPItem;
import 'package:another_authenticator/intl/intl.dart' show AppLocalizations;
import './edit_list_item.dart' show EditListItem;

/// Android edit page.
class AndroidEditPage extends StatefulWidget {
  AndroidEditPage(this.items, this._itemsChanged, this.replaceItems, {Key key})
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

class _EditPageState extends State<AndroidEditPage> {
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

  // Hide bottom bar
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

  // Remove dialog
  void showRemoveDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(AppLocalizations.of(context).removeAccounts),
              content: Text(AppLocalizations.of(context).removalConfirmation),
              actions: [
                FlatButton(
                    child: Text(AppLocalizations.of(context).no),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                FlatButton(
                  child: Text(AppLocalizations.of(context).yes,
                      style: const TextStyle(color: Colors.red)),
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

  // Handle history pop
  Future<bool> _popCallback() async {
    if (!widget.itemsChanged) {
      return true;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(AppLocalizations.of(context).exitEditTitle),
              content: Text(AppLocalizations.of(context).exitEditInfo),
              actions: [
                FlatButton(
                    child: Text(AppLocalizations.of(context).no),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                FlatButton(
                  child: Text(AppLocalizations.of(context).yes,
                      style: const TextStyle(color: Colors.red)),
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
        child: Scaffold(
            appBar: AppBar(
                title: Text(AppLocalizations.of(context).editTitle),
                actions: <Widget>[
                  // Save
                  ValueListenableBuilder<bool>(
                      valueListenable: _hideSave,
                      builder: (context, value, child) {
                        if (value) {
                          return Container();
                        } else {
                          return IconButton(
                              icon: const Icon(Icons.check),
                              tooltip: AppLocalizations.of(context).save,
                              onPressed: () {
                                widget.replaceItems(widget.items);
                                Navigator.pop(context);
                              });
                        }
                      })
                ]),
            body: widget.items == null
                ? Center(child: Text(AppLocalizations.of(context).loading))
                : Container(
                    margin: const EdgeInsets.all(10),
                    child: ReorderableListView(
                        padding: const EdgeInsets.all(0),
                        scrollDirection: Axis.vertical,
                        children: widget.items
                            .map((item) => EditListItem(
                                item, addRemovalItem, removeRemovalItem,
                                key: Key(item.id)))
                            .toList(),
                        onReorder: _handleReorder)),
            // Delete button
            bottomSheet: ValueListenableBuilder<bool>(
              valueListenable: _hideTrash,
              builder: (context, value, child) {
                if (value == true) {
                  return Container(width: 0, height: 0);
                }
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: FlatButton(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {
                              showRemoveDialog(context);
                            },
                            child: Text(
                                AppLocalizations.of(context).removeAccounts,
                                style:
                                    const TextStyle(color: Colors.redAccent))))
                  ],
                );
              },
            )));
  }
}
