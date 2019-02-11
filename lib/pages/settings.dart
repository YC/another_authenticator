import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show ListTile, Icons, Material;
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:another_authenticator/intl/intl.dart' show AppLocalizations;
import 'package:another_authenticator/ui/adaptive.dart'
    show AppScaffold, isPlatformAndroid, getScaffoldColor;
import 'package:another_authenticator/helper/url.dart' show launchURL;
import 'package:another_authenticator/helper/info.dart' show AppInfo;

/// Settings page.
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(AppLocalizations.of(context).settingsTitle),
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
                                  image:
                                      const AssetImage('graphics/icon.png'))))),
                  Container(
                      width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Text(AppLocalizations.of(context).appName,
                                  style: const TextStyle(fontSize: 25))),
                          // Version of app
                          FutureBuilder(
                              future: AppInfo.getAppInfo(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<AppInfo> snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data.version,
                                      style: const TextStyle(fontSize: 14));
                                }
                                return Text(
                                    AppLocalizations.of(context).loading);
                              }),
                        ],
                      ))
                ],
              )),
          // List of options
          Expanded(
              child: Material(
                  color: getScaffoldColor(context),
                  child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Source
                        ListTile(
                            dense: true,
                            leading: const Icon(Icons.code),
                            title: Text(AppLocalizations.of(context).sourceCode,
                                style: const TextStyle(fontSize: 15)),
                            onTap: () {
                              launchURL(AppLocalizations.repo);
                            }),
                        // Acknowledgements
                        ListTile(
                            dense: true,
                            leading: isPlatformAndroid()
                                ? const Icon(Icons.book)
                                : const Icon(CupertinoIcons.book),
                            title: Text(AppLocalizations.of(context).licenses,
                                style: const TextStyle(fontSize: 15)),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed('/settings/acknowledgements');
                            }),
                      ]))),
        ],
      ),
    );
  }
}
