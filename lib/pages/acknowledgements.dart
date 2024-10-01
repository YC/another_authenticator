/// Acknowledgements page
///
/// Various code from:
/// https://github.com/flutter/flutter/blob/efb1346767e67d2577461baf671eb2d5d2c4bb90/packages/flutter/lib/src/material/about.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart'
    show
        CircularProgressIndicator,
        Divider,
        ListTile,
        Material,
        MaterialPageRoute,
        Theme;
import '../ui/adaptive.dart' show AppScaffold;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AcknowledgementsPage extends StatefulWidget {
  const AcknowledgementsPage({
    super.key,
  });

  @override
  State<AcknowledgementsPage> createState() => _AcknowledgementsPageState();
}

/// Acknowledgements page for used libraries.
class _AcknowledgementsPageState extends State<AcknowledgementsPage> {
  // Adapted from flutter/flutter
  final Future<_LicenseData> licenses = LicenseRegistry.licenses
      .fold<_LicenseData>(
        _LicenseData(),
        (_LicenseData prev, LicenseEntry license) => prev..addLicense(license),
      )
      .then((_LicenseData licenseData) => licenseData..sortPackages());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(AppLocalizations.of(context)!.licenses),
      body: FutureBuilder<_LicenseData>(
        future: licenses,
        builder: (BuildContext context, AsyncSnapshot<_LicenseData> snapshot) {
          return LayoutBuilder(
            key: ValueKey<ConnectionState>(snapshot.connectionState),
            builder: (BuildContext context, BoxConstraints constraints) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  return Material(
                    child: ListView.separated(
                      itemCount: snapshot.data!.count(),
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 0, width: 0),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          dense: true,
                          title: Text(snapshot.data!.getTitle(index)),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FullScreenLicense(
                                  snapshot.data!.getTitle(index),
                                  snapshot.data!.getLicenses(index),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Material(
                    color: Theme.of(context).cardColor,
                    child: const Center(child: CircularProgressIndicator()),
                  );
              }
            },
          );
        },
      ),
    );
  }
}

/// Full screen license widget
class FullScreenLicense extends StatelessWidget {
  /// The name
  final String title;

  /// License
  final List<LicenseEntry> licenseEntries;

  const FullScreenLicense(this.title, this.licenseEntries, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> licenses = <Widget>[];
    for (var (index, licenseEntry) in licenseEntries.indexed) {
      if (index != 0) {
        licenses.add(const Divider());
      }
      licenses.addAll(licenseEntry.paragraphs.map((p) {
        // Adapted from flutter/flutter
        if (p.indent == LicenseParagraph.centeredIndent) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              p.text,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return Padding(
            padding:
                EdgeInsetsDirectional.only(top: 8.0, start: 16.0 * p.indent),
            child: Text(p.text),
          );
        }
      }));
    }

    return AppScaffold(
      title: Text(title),
      body: Material(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Column(children: licenses),
          ),
        ),
      ),
    );
  }
}

/// Adapted from flutter/flutter
/// With renames and addition of helper methods.
///
/// This is a collection of licenses and the packages to which they apply.
/// [_packageLicenseBindings] records the m+:n+ relationship between the license
/// and packages as a map of package names to license indexes.
class _LicenseData {
  final List<LicenseEntry> _licenses = <LicenseEntry>[];
  final Map<String, List<int>> _packageLicenseBindings = <String, List<int>>{};
  final List<String> _packages = <String>[];

  // Special treatment for the first package since it should be the package
  // for delivered application.
  String? firstPackage;

  void addLicense(LicenseEntry entry) {
    // Before the license can be added, we must first record the packages to
    // which it belongs.
    for (final String package in entry.packages) {
      _addPackage(package);
      // Bind this license to the package using the next index value. This
      // creates a contract that this license must be inserted at this same
      // index value.
      _packageLicenseBindings[package]!.add(_licenses.length);
    }
    _licenses.add(entry); // Completion of the contract above.
  }

  /// Add a package and initialize package license binding. This is a no-op if
  /// the package has been seen before.
  void _addPackage(String package) {
    if (!_packageLicenseBindings.containsKey(package)) {
      _packageLicenseBindings[package] = <int>[];
      firstPackage ??= package;
      _packages.add(package);
    }
  }

  /// Sort the packages using some comparison method, or by the default manner,
  /// which is to put the application package first, followed by every other
  /// package in case-insensitive alphabetical order.
  void sortPackages([int Function(String a, String b)? compare]) {
    _packages.sort(compare ??
        (String a, String b) {
          // Based on how LicenseRegistry currently behaves, the first package
          // returned is the end user application license. This should be
          // presented first in the list. So here we make sure that first package
          // remains at the front regardless of alphabetical sorting.
          if (a == firstPackage) {
            return -1;
          }
          if (b == firstPackage) {
            return 1;
          }
          return a.toLowerCase().compareTo(b.toLowerCase());
        });
  }

  int count() {
    return _packages.length;
  }

  String getTitle(int index) {
    return _packages[index];
  }

  List<LicenseEntry> getLicenses(int index) {
    var package = _packages[index];
    return _getLicensesForPackage(package);
  }

  List<LicenseEntry> _getLicensesForPackage(String package) {
    var bindings = _packageLicenseBindings[package]!;
    return bindings.map((b) => _licenses[b]).toList();
  }
}
