import '../../state/app_state.dart';
import 'package:another_authenticator_state/legacy/legacy_authenticator_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import './list_item.dart';

/// Cupertino version of home page.
class CupertinoHomePage extends StatelessWidget {
  const CupertinoHomePage({super.key});

  /// Builds list of items.
  Widget _buildList(BuildContext context) {
    var backgroundColour =
        CupertinoTheme.of(context).brightness == Brightness.light
            ? CupertinoColors.extraLightBackgroundGray
            : CupertinoColors.darkBackgroundGray;

    return Consumer<AppState>(
      builder: (context, state, child) {
        if (state.items == null) {
          // Items loading
          return Container(
            color: backgroundColour,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(AppLocalizations.of(context)!.loading),
              ),
            ),
          );
        } else if (state.items!.isEmpty) {
          // No Items
          return Container(
            color: backgroundColour,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  AppLocalizations.of(context)!.noAccounts,
                  textAlign: TextAlign.center,
                  style: const TextStyle(height: 1.2),
                ),
              ),
            ),
          );
        }

        return Container(
          color: backgroundColour,
          margin: const EdgeInsets.symmetric(vertical: 5),
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
  void _showAddModal(BuildContext context) {
    // Show dialog
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(AppLocalizations.of(context)!.addTitle),
          message: Text(AppLocalizations.of(context)!.addMethodPrompt),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context)!.addScanQR),
              onPressed: () async {
                Navigator.pop(context);

                var result = await Navigator.pushNamed(context, "/add/scan");
                if (result == null) {
                  return;
                }
                // TODO: Transition to new type
                var item = result as LegacyAuthenticatorItem;
                await Provider.of<AppState>(context, listen: false)
                    .addItem(item.totp);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context)!.addManualInput),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/add");
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(start: 5, end: 10),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).pushNamed('/edit');
              },
              child: const Text("Edit"),
            )
          ],
        ),
        // Add
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.add_circled,
            semanticLabel: 'Add',
          ),
          onPressed: () {
            _showAddModal(context);
          },
        ),
        middle: Text(AppLocalizations.of(context)!.appName),
      ),
      child: _buildList(context),
    );
  }
}
