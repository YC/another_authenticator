import 'package:flutter/cupertino.dart';
import 'package:another_authenticator/totp/totp.dart';
import 'package:another_authenticator/intl/intl.dart' show AppLocalizations;
import './list_item.dart';

/// Cupertino version of home page.
class CupertinoHomePage extends StatefulWidget {
  CupertinoHomePage(this.items, {Key key}) : super(key: key);

  /// List of TOTP items
  final List<TOTPItem> items;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CupertinoHomePage> {
  /// Builds list of items.
  Widget _buildList() {
    Color backgroundColour =
        CupertinoTheme.of(context).brightness == Brightness.light
            ? CupertinoColors.extraLightBackgroundGray
            : CupertinoColors.darkBackgroundGray;

    if (widget.items == null) {
      // Items loading
      return Container(
          color: backgroundColour,
          child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(AppLocalizations.of(context).loading))));
    } else if (widget.items.length == 0) {
      // No Items
      return Container(
          color: backgroundColour,
          child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(AppLocalizations.of(context).noAccounts,
                      textAlign: TextAlign.center,
                      style: const TextStyle(height: 1.2)))));
    }
    return Container(
        color: backgroundColour,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (BuildContext context, int index) {
              var item = widget.items[index];
              return HomeListItem(item, key: Key(item.id));
            }));
  }

  /// Shows add modal
  void showAddModal(BuildContext context) {
    // Show dialog
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
              title: Text(AppLocalizations.of(context).addTitle),
              message: Text(AppLocalizations.of(context).addMethodPrompt),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text(AppLocalizations.of(context).addScanQR),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/add/scan");
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(AppLocalizations.of(context).addManualInput),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/add");
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text(AppLocalizations.of(context).cancel),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            padding: const EdgeInsetsDirectional.only(start: 5, end: 10),
            leading: Row(mainAxisSize: MainAxisSize.min, children: [
              // Settings
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.settings,
                  semanticLabel: 'Settings',
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              // Edit
              CupertinoButton(
                child: Text("Edit"),
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).pushNamed('/edit');
                },
              )
            ]),
            // Add
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.add_circled,
                semanticLabel: 'Add',
              ),
              onPressed: () {
                showAddModal(context);
              },
            ),
            middle: Text(AppLocalizations.of(context).appName)),
        child: _buildList());
  }
}
