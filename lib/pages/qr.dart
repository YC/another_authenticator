import 'dart:async' show Future;
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter/widgets.dart';
import 'package:another_authenticator/totp/totp.dart' show TOTPItem;
import 'package:another_authenticator/intl/intl.dart' show AppLocalizations;
import 'package:another_authenticator/ui/adaptive.dart'
    show AppScaffold, showAdaptiveDialog, AdaptiveDialogAction;
import 'package:barcode_scan2/barcode_scan2.dart' show BarcodeScanner;

/// Page for adding accounts by scanning QR.
class ScanQRPage extends StatefulWidget {
  const ScanQRPage({Key key}) : super(key: key);

  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  void initState() {
    super.initState();

    // Trigger scan
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final value = await _scan();
        // Parse scanned value into item and pop
        var item = TOTPItem.fromUri(value);
        // Pop until scan page
        Navigator.of(context).popUntil(ModalRoute.withName('/add/scan'));
        // Pop with scanned item
        Navigator.of(context).pop(item);
      } catch (e) {
        await showAdaptiveDialog(
          context,
          title: Text(AppLocalizations.of(context).error),
          content:
              Text(AppLocalizations.of(context).getErrorMessage(e.message)),
          actions: [
            AdaptiveDialogAction(
              child: Text(AppLocalizations.of(context).ok),
              onPressed: () {
                // Pop dialog
                Navigator.of(context).pop();
              },
            )
          ],
        );
        Navigator.of(context).popUntil(ModalRoute.withName('/add/scan'));
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(AppLocalizations.of(context).addScanQR),
      body: const Center(),
    );
  }

  // Scans and returns scanned QR code
  // Adapted from documentation of flutter_barcode_reader
  Future _scan() async {
    try {
      var barcode = await BarcodeScanner.scan();
      return barcode.rawContent;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        return Future.error(AppLocalizations.of(context).errNoCameraPermission);
      } else {
        return Future.error('${AppLocalizations.of(context).errUnknown} $e');
      }
    } on FormatException {
      return Future.error(AppLocalizations.of(context).errIncorrectFormat);
    } catch (e) {
      return Future.error('${AppLocalizations.of(context).errUnknown} $e');
    }
  }
}
