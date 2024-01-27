import 'package:another_authenticator/state/app_state.dart';
import 'package:another_authenticator_state/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ReorderableListView, Icons;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import './edit_list_item.dart' show EditListItem;

/// Cupertino edit page.
class CupertinoEditPage extends StatefulWidget {
  CupertinoEditPage({Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<CupertinoEditPage> {
  List<LegacyAuthenticatorItem>? items;

  // Remove items with given ids
  void removeItems(List<String> itemIDs) {
    items!.removeWhere((item) => itemIDs.contains(item.id));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => items =
          List<LegacyAuthenticatorItem>.from(context.read<AppState>().items!));
    });
  }

  // Handles reorder of elements
  void _handleReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      items!.insert(newIndex, items!.removeAt(oldIndex));
      _refreshHide();
    });
  }

  // Whether to hide trash icon
  ValueNotifier<bool> _hideTrash = ValueNotifier(true);
  // Whether to hide save icon
  ValueNotifier<bool> _hideSave = ValueNotifier(true);

  // List of selected items (to be removed)
  final List<String> _pendingRemovalList = [];

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
    _hideSave.value =
        !Provider.of<AppState>(context, listen: false).itemsChanged(items);
  }

  // Item remove dialog
  void showRemoveDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.removeAccounts),
          content: Text(AppLocalizations.of(context)!.removeConfirmation),
          actions: [
            CupertinoDialogAction(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context)!.ok),
              onPressed: () {
                setState(() {
                  removeItems(_pendingRemovalList);
                  _pendingRemovalList.clear();
                  _refreshHide();
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  // Handle history pop (back button)
  void _popCallback(bool didPop) {
    if (didPop) return;

    // No change to items
    if (!Provider.of<AppState>(context, listen: false).itemsChanged(items)) {
      Navigator.of(context).pop();
      return;
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.exitEditTitle),
          content: Text(AppLocalizations.of(context)!.exitEditInfo),
          actions: [
            CupertinoDialogAction(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context)!.ok),
              onPressed: () {
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: _popCallback,
      canPop: false,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(AppLocalizations.of(context)!.editTitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Trash Icon
              ValueListenableBuilder<bool>(
                valueListenable: _hideTrash,
                builder: (context, value, child) {
                  return value
                      ? Container()
                      : CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          child: const Icon(CupertinoIcons.delete),
                          onPressed: () => showRemoveDialog(context));
                },
              ),
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
                        if (items != null) {
                          Provider.of<AppState>(context, listen: false)
                              .replaceItems(items!);
                        }
                        Navigator.pop(context);
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
        child: items == null
            ? Center(child: Text(AppLocalizations.of(context)!.loading))
            : SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  color:
                      CupertinoTheme.of(context).brightness == Brightness.light
                          ? CupertinoColors.extraLightBackgroundGray
                          : CupertinoColors.darkBackgroundGray,
                  child: ReorderableListView(
                      scrollDirection: Axis.vertical,
                      children: items!
                          .map((item) => EditListItem(
                              item, addRemovalItem, removeRemovalItem,
                              key: Key(item.id)))
                          .toList(),
                      onReorder: _handleReorder),
                ),
              ),
      ),
    );
  }
}
