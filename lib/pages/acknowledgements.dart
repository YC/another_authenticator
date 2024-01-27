import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart'
    show Divider, ListTile, Material, MaterialPageRoute;
import 'package:another_authenticator/ui/adaptive.dart' show AppScaffold;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const _license_dir = 'assets/licenses';
const _libs = [
  {'title': 'Flutter', 'path': '$_license_dir/flutter-flutter.txt'},
  {'title': 'flutter/plugins', 'path': '$_license_dir/flutter-flutter.txt'},
  {
    'title': 'flutter/cupertino_icons',
    'path': '$_license_dir/flutter-cupertino_icons.txt'
  },
  {'title': 'dart-lang/crypto', 'path': '$_license_dir/dartlang-crypto.txt'},
  {'title': 'dart-lang/intl', 'path': '$_license_dir/dartlang-intl.txt'},
  {
    'title': 'mono0926/barcode_scan2',
    'path': '$_license_dir/mono0926-barcode_scan2.txt'
  },
  {
    'title': 'Daegalus/dart-uuid',
    'path': '$_license_dir/daegalus-dart-uuid.txt'
  }
];

/// Acknowledgements page for used libraries.
class AcknowledgementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(AppLocalizations.of(context)!.licenses),
      body: Material(
        // color: getScaffoldColor(context),
        child: ListView.separated(
          itemCount: _libs.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 0),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              dense: true,
              title: Text(_libs[index]['title']!),
              onTap: () {
                if (_libs[index]['path'] != null) {
                  rootBundle.loadString(_libs[index]['path']!).then((text) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreenLicense(
                            _libs[index]['title']!, text.trim()),
                      ),
                    );
                  }).catchError((_) => null);
                }
              },
            );
          },
        ),
      ),
    );
  }
}

/// Full screen license widget
class FullScreenLicense extends StatelessWidget {
  /// The name
  final String title;

  /// License
  final String license;

  FullScreenLicense(this.title, this.license);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(this.title),
      body: Material(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(this.license),
          ),
        ),
      ),
    );
  }
}
