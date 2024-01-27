import 'package:another_authenticator/state/app_state.dart';
import 'package:another_authenticator_state/state.dart';
import 'package:flutter/material.dart';
import 'package:another_authenticator/helper/url.dart' show launchURL;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../l10n/constants.dart' as Constants;
import './list_item.dart' show HomeListItem;

/// Android version of home page.
class AndroidHomePage extends StatelessWidget {
  /// Builds list of items.
  Widget _buildList() {
    return Consumer<AppState>(
      builder: (context, state, child) {
        if (state.items == null) {
          // Items loading
          return Center(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(AppLocalizations.of(context)!.loading)));
        } else if (state.items!.length == 0) {
          // No Items
          return Center(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(AppLocalizations.of(context)!.noAccounts,
                      textAlign: TextAlign.center,
                      style: const TextStyle(height: 1.2))));
        }

        return Container(
          margin: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: state.items!.length,
            itemBuilder: (BuildContext context, int index) {
              var item = state.items![index];
              return HomeListItem(item, key: Key(item.id));
            },
          ),
        );
      },
    );
  }

  /// Shows add modal
  void showAddModal(BuildContext context) {
    // Show bottom sheet
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              // Scan QR
              ListTile(
                title: Text(AppLocalizations.of(context)!.addScanQR),
                leading: const Icon(Icons.camera_alt),
                onTap: () async {
                  Navigator.pop(context);
                  final item =
                      await Navigator.pushNamed<LegacyAuthenticatorItem>(
                          context, "/add/scan");
                  if (item != null) {
                    await Provider.of<AppState>(context, listen: false)
                        .addItem(item);
                  }
                },
              ),
              // Add account manually
              ListTile(
                title: Text(AppLocalizations.of(context)!.addManualInput),
                leading: const Icon(Icons.keyboard_return),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/add");
                },
              ),
            ],
          ),
        );
      },
    );
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
                  Text(
                    AppLocalizations.of(context)!.appName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize),
                  ),
                ],
              ),
            ),
            // Settings
            ListTile(
                title: Text(AppLocalizations.of(context)!.settingsTitle),
                leading: const Icon(Icons.settings),
                dense: true,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/settings");
                }),
            Divider(height: 10),
            // Source code (in-app browser link)
            ListTile(
                title: Text(AppLocalizations.of(context)!.source),
                leading: const Icon(Icons.code),
                dense: true,
                onTap: () {
                  Navigator.pop(context);
                  launchURL(Constants.REPO);
                }),
            // License
            ListTile(
              title: Text(AppLocalizations.of(context)!.licenses),
              leading: const Icon(Icons.book),
              dense: true,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/settings/acknowledgements");
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
        actions: <Widget>[
          // Edit
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: AppLocalizations.of(context)!.edit,
            onPressed: () {
              Navigator.pushNamed(context, '/edit');
            },
          ),
          // Add
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.add,
            onPressed: () {
              showAddModal(context);
            },
          )
        ],
      ),
      body: _buildList(),
    );
  }
}
