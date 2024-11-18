import '../../config/routes.dart';
import '../../state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import './edit_list_item.dart' show EditListItem;

/// Android edit page.
class AndroidEditPage extends StatefulWidget {
  const AndroidEditPage({super.key});

  @override
  State<AndroidEditPage> createState() => _EditPageState();
}

class _EditPageState extends State<AndroidEditPage> {
  List<BaseItemType>? items;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() =>
          items = List<BaseItemType>.from(context.read<AppState>().items!));
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

  // Hide bottom bar
  final ValueNotifier<bool> _hideTrash = ValueNotifier(true);
  // Whether to hide save icon
  final ValueNotifier<bool> _hideSave = ValueNotifier(true);

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

  // Remove items with given ids
  void removeItems(List<String> itemIDs) {
    items!.removeWhere((item) => itemIDs.contains(item.id));
  }

  // Refreshes value of _hide
  void _refreshHide() {
    _hideTrash.value = _pendingRemovalList.isEmpty;
    _hideSave.value =
        !Provider.of<AppState>(context, listen: false).itemsChanged(items);
  }

  // Remove dialog
  void showRemoveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.removeAccounts),
          content: Text(AppLocalizations.of(context)!.removeConfirmation),
          actions: [
            TextButton(
                child: Text(AppLocalizations.of(context)!.no),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: Text(AppLocalizations.of(context)!.yes,
                  style: const TextStyle(color: Colors.red)),
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

  // Handle history pop
  void _popCallback(bool didPop) async {
    if (didPop) return;

    // No change to items
    if (!Provider.of<AppState>(context, listen: false).itemsChanged(items)) {
      Navigator.of(context).pop();
      return;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.exitEditTitle),
          content: Text(AppLocalizations.of(context)!.exitEditInfo),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.no),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.yes,
                  style: const TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(AppRoutes.home));
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
      canPop: false,
      onPopInvoked: _popCallback,
      child: Theme(
        data: Theme.of(context).copyWith(
          bottomSheetTheme: const BottomSheetThemeData(
            surfaceTintColor: Colors.transparent,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.editTitle),
            actions: <Widget>[
              // Save
              ValueListenableBuilder<bool>(
                valueListenable: _hideSave,
                builder: (context, hideSave, child) {
                  return hideSave
                      ? Container()
                      : IconButton(
                          icon: const Icon(Icons.check),
                          tooltip: AppLocalizations.of(context)!.save,
                          onPressed: () {
                            if (items != null) {
                              Provider.of<AppState>(context, listen: false)
                                  .replaceItems(items!);
                            }
                            Navigator.pop(context);
                          },
                        );
                },
              )
            ],
          ),

          body: items == null
              ? Center(child: Text(AppLocalizations.of(context)!.loading))
              : Container(
                  margin: const EdgeInsets.all(10),
                  child: ReorderableListView(
                      padding: const EdgeInsets.all(0),
                      scrollDirection: Axis.vertical,
                      onReorder: _handleReorder,
                      children: items!
                          .map((item) => EditListItem(
                              item, addRemovalItem, removeRemovalItem,
                              key: Key(item.id)))
                          .toList())),

          // Delete button
          bottomSheet: ValueListenableBuilder<bool>(
            valueListenable: _hideTrash,
            builder: (context, value, child) {
              return value
                  ? const SizedBox.shrink()
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              showRemoveDialog(context);
                            },
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              side: BorderSide.none,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.removeAccounts,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
