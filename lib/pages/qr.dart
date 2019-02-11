import 'dart:async' show Future;
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter/widgets.dart';
import 'package:another_authenticator/totp/totp.dart' show TOTPItem;
import 'package:another_authenticator/intl/intl.dart' show AppLocalizations;
import 'package:another_authenticator/ui/adaptive.dart'
    show AppScaffold, showAdaptiveDialog, AdaptiveDialogAction;
import 'package:barcode_scan/barcode_scan.dart' show BarcodeScanner;

/// Page for adding accounts by scanning QR.
class ScanQRPage extends StatefulWidget {
  ScanQRPage(this.addItem, {Key key}) : super(key: key);

  // Adds an item
  final Function addItem;

  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  @override
  initState() {
    super.initState();

    // Scan QR
    scan().then((value) {
      // Successful, parse scanned URI and add account
      try {
        var item = TOTPItem.fromUri(value);
        widget.addItem(item);
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
      } catch (e) {
        showAdaptiveDialog(context,
            title: Text(AppLocalizations.of(context).error),
            content:
                Text(AppLocalizations.of(context).getErrorMessage(e.message)),
            actions: [
              AdaptiveDialogAction(
                  child: Text(AppLocalizations.of(context).ok),
                  onPressed: () {
                    Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  })
            ]);
      }
    }).catchError((error) {
      // Unsuccessful, return to home
      Navigator.pop(context);
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
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      return Future.value(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
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
