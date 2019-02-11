import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Divider, ListTile, Material;
import 'package:another_authenticator/intl/intl.dart' show AppLocalizations;
import 'package:another_authenticator/ui/adaptive.dart' show AppScaffold, getScaffoldColor;
import 'package:another_authenticator/helper/url.dart' show launchURL;

/// Acknowledgements page for used libraries.
class AcknowledgementsPage extends StatelessWidget {
  static const _libs = [
    {
      'title': 'Flutter',
      'url': 'https://raw.githubusercontent.com/flutter/flutter/master/LICENSE'
    },
    {
      'title': 'flutter/plugins',
      'url': 'https://raw.githubusercontent.com/flutter/plugins/master/LICENSE'
    },
    {
      'title': 'flutter/cupertino_icons',
      'url':
          'https://raw.githubusercontent.com/flutter/cupertino_icons/master/LICENSE'
    },
    {
      'title': 'dart-lang/crypto',
      'url': 'https://raw.githubusercontent.com/dart-lang/crypto/master/LICENSE'
    },
    {
      'title': 'apptreesoftware/flutter_barcode_reader',
      'url':
          'https://raw.githubusercontent.com/apptreesoftware/flutter_barcode_reader/master/LICENSE'
    },
    {
      'title': 'Daegalus/dart-uuid',
      'url':
          'https://raw.githubusercontent.com/Daegalus/dart-uuid/master/LICENSE'
    },
    {
      'title': 'brianegan/flutter_architecture_samples',
      'url': 'https://github.com/brianegan/flutter_architecture_samples'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(AppLocalizations.of(context).licenses),
      body: Material(
          color: getScaffoldColor(context),
          child: ListView.separated(
            itemCount: _libs.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 0),
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                dense: true,
                onTap: () {
                  launchURL(_libs[index]['url']);
                },
                title: Text(_libs[index]['title'],
                    style: DefaultTextStyle.of(context).style),
              );
            },
          )),
    );
  }
}
