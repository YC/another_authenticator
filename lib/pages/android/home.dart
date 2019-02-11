import 'package:flutter/material.dart';
import 'package:another_authenticator/helper/url.dart' show launchURL;
import 'package:another_authenticator/totp/totp.dart' show TOTPItem;
import 'package:another_authenticator/intl/intl.dart' show AppLocalizations;
import './list_item.dart' show HomeListItem;

/// Android version of home page.
class AndroidHomePage extends StatefulWidget {
  AndroidHomePage(this.items, {Key key}) : super(key: key);

  /// List of TOTP items
  final List<TOTPItem> items;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AndroidHomePage> {
  /// Builds list of items.
  Widget _buildList() {
    if (widget.items == null) {
      // Items loading
      return Center(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(AppLocalizations.of(context).loading)));
    } else if (widget.items.length == 0) {
      // No Items
      return Center(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(AppLocalizations.of(context).noAccounts,
                  textAlign: TextAlign.center,
                  style: const TextStyle(height: 1.2))));
    }
    return Container(
        margin: const EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (BuildContext context, int index) {
              var item = widget.items[index];
              return HomeListItem(item, key: Key(item.id));
            }));
  }

  /// Shows add modal
  void showAddModal(BuildContext context) {
    // Show bottom sheet
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.all(8.0),
              child: ListView(shrinkWrap: true, children: <Widget>[
                // Scan QR
                ListTile(
                  title: Text(AppLocalizations.of(context).addScanQR),
                  leading: const Icon(Icons.camera_alt),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/add/scan");
                  },
                ),
                // Add account manually
                ListTile(
                  title: Text(AppLocalizations.of(context).addManualInput),
                  leading: const Icon(Icons.keyboard_return),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/add");
                  },
                ),
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context).appName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  Theme.of(context).textTheme.title.fontSize)),
                    ])),
            // Settings
            ListTile(
                title: Text(AppLocalizations.of(context).settingsTitle),
                leading: const Icon(Icons.settings),
                dense: true,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/settings");
                }),
            Divider(height: 10),
            // Source code (in-app browser link)
            ListTile(
                title: Text(AppLocalizations.of(context).sourceCode),
                leading: const Icon(Icons.code),
                dense: true,
                onTap: () {
                  Navigator.pop(context);
                  launchURL(AppLocalizations.repo);
                }),
            // License
            ListTile(
                title: Text(AppLocalizations.of(context).licenses),
                leading: const Icon(Icons.book),
                dense: true,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/settings/acknowledgements");
                }),
          ],
        ),
      ),
      appBar: AppBar(
          title: Text(AppLocalizations.of(context).appName),
          actions: <Widget>[
            // Edit
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: AppLocalizations.of(context).edit,
              onPressed: () {
                Navigator.pushNamed(context, '/edit');
              },
            ),
            // Add
            IconButton(
                icon: const Icon(Icons.add),
                tooltip: AppLocalizations.of(context).add,
                onPressed: () {
                  showAddModal(context);
                })
          ]),
      body: _buildList(),
    );
  }
}
