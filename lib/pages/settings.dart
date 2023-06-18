import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show ListTile, Icons;
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:another_authenticator/ui/adaptive.dart'
    show AppScaffold, isPlatformAndroid;
import 'package:another_authenticator/helper/url.dart' show launchURL;
import 'package:package_info/package_info.dart' show PackageInfo;
import '../l10n/constants.dart' as Constants;

/// Settings page.
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(AppLocalizations.of(context)!.settingsTitle),
      body: Column(
        children: <Widget>[
          // App Info
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // App image
                Container(
                  height: 125,
                  width: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const DecoratedBox(
                    decoration: const BoxDecoration(
                      image: const DecorationImage(
                        image: const AssetImage('graphics/icon.png'),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Name
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(AppLocalizations.of(context)!.appName,
                              style: const TextStyle(fontSize: 25))),
                      // Version of app
                      FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (BuildContext context,
                            AsyncSnapshot<PackageInfo> snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data!.version,
                                style: const TextStyle(fontSize: 14));
                          }
                          return Text(AppLocalizations.of(context)!.loading);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // List of options
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Source
                ListTile(
                    dense: true,
                    leading: const Icon(Icons.code),
                    title: Text(AppLocalizations.of(context)!.source,
                        style: const TextStyle(fontSize: 15)),
                    onTap: () {
                      launchURL(Constants.REPO);
                    }),
                // Acknowledgements
                ListTile(
                  dense: true,
                  leading: isPlatformAndroid()
                      ? const Icon(Icons.book)
                      : const Icon(CupertinoIcons.book),
                  title: Text(AppLocalizations.of(context)!.licenses,
                      style: const TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/settings/acknowledgements');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
