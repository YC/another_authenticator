import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:another_authenticator/ui/adaptive.dart';
import 'package:another_authenticator/totp/totp.dart' show TOTPItem, Base32;
import 'package:another_authenticator/intl/intl.dart' show AppLocalizations;

/// Page for adding accounts.
class AddPage extends StatefulWidget {
  AddPage(this.addItem, {Key key}) : super(key: key);

  // Adds an item
  final Function addItem;

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  // Uniquely identify Form widget for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text field controllers
  final _issuerController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _secretController = TextEditingController();

  // Value of dropdown fields
  int _digits = 6;
  int _period = 30;

  @override
  void initState() {
    super.initState();

    // Add listener to secret controller
    _secretController.addListener(_enableSecretAutoValidation);
  }

  // Enable validation when text is changed (but don't validate initially)
  bool _secretAutoValidation = false;
  void _enableSecretAutoValidation() {
    if (_secretController.text.isEmpty) return;
    _secretController.removeListener(_enableSecretAutoValidation);
    setState(() {
      _secretAutoValidation = true;
    });
  }

  @override
  dispose() {
    _issuerController.dispose();
    _accountNameController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  // Adds item or display errors
  void addItem(TOTPItem item) {
    try {
      widget.addItem(item);
      Navigator.pop(context);
    } catch (e) {
      showAdaptiveDialog(context,
          title: Text(AppLocalizations.of(context).error),
          content:
              Text(AppLocalizations.of(context).getErrorMessage(e.message)),
          actions: [
            AdaptiveDialogAction(
                child: Text(AppLocalizations.of(context).ok),
                onPressed: Navigator.of(context).pop)
          ]);
    }
  }

  /// Whether the secret field is valid
  bool secretFieldValid() {
    return _secretController.text.isNotEmpty &&
        Base32.isBase32(_secretController.text);
  }

  // Handle add action
  void handleAdd() {
    // Validate
    if (!_formKey.currentState.validate()) {
      return;
    }
    // No iOS validator, so may need to recheck and fail
    if (!secretFieldValid()) {
      showAdaptiveDialog(context,
          title: Text(AppLocalizations.of(context).error),
          content: Text(AppLocalizations.of(context).secretInvalidMessage),
          actions: [
            AdaptiveDialogAction(
                child: Text(AppLocalizations.of(context).ok),
                onPressed: Navigator.of(context).pop)
          ]);
      return;
    }

    // Initialise and add TOTP item
    var item = TOTPItem.newTOTPItem(_secretController.text, _digits, _period,
        "sha1", _issuerController.text, _accountNameController.text);
    addItem(item);
  }

  // Separates fields
  // Adapted from flutter examples
  static const BorderSide _greyBorder = BorderSide(
    color: CupertinoColors.lightBackgroundGray,
    style: BorderStyle.solid,
    width: 0.0,
  );
  static const _boxDecoration = BoxDecoration(
      border: Border(
          bottom: _greyBorder,
          top: _greyBorder,
          left: BorderSide.none,
          right: BorderSide.none));

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(AppLocalizations.of(context).addTitle),
      cupertinoNavigationBar: CupertinoNavigationBar(
          middle: Text(AppLocalizations.of(context).addTitle),
          trailing: CupertinoButton(
              padding: const EdgeInsets.all(0),
              child: Text(AppLocalizations.of(context).add),
              onPressed: handleAdd)),
      body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: ListView(
                children: <Widget>[
                  // Key
                  AdaptiveTextField(
                      controller: _secretController,
                      textCapitalization: TextCapitalization.characters,
                      autocorrect: false,
                      androidData: AdaptiveAndroidTextFieldData(
                        autovalidate: _secretAutoValidation,
                        validator: (value) => secretFieldValid()
                            ? null
                            : AppLocalizations.of(context).secretInvalidMessage,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).secret),
                      ),
                      cupertinoData: AdaptiveCupertinoTextFieldData(
                          decoration: _boxDecoration,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          prefix: Text(AppLocalizations.of(context).secret),
                          textAlign: TextAlign.right)),
                  // Provider
                  AdaptiveTextField(
                      controller: _issuerController,
                      textCapitalization: TextCapitalization.words,
                      androidData: AdaptiveAndroidTextFieldData(
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).issuer,
                              hintText: 'Example Service')),
                      cupertinoData: AdaptiveCupertinoTextFieldData(
                          decoration: _boxDecoration,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          prefix: Text(AppLocalizations.of(context).issuer),
                          textAlign: TextAlign.right)),
                  // Account name
                  AdaptiveTextField(
                      controller: _accountNameController,
                      keyboardType: TextInputType.emailAddress,
                      androidData: AdaptiveAndroidTextFieldData(
                          decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context).accountName,
                              hintText: 'user@example.com')),
                      cupertinoData: AdaptiveCupertinoTextFieldData(
                          decoration: _boxDecoration,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          prefix:
                              Text(AppLocalizations.of(context).accountName),
                          textAlign: TextAlign.right)),
                  // # of digits
                  isPlatformAndroid()
                      ? InputDecorator(
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 15),
                              labelText: AppLocalizations.of(context).digits,
                              border: InputBorder.none,
                              labelStyle: const TextStyle(fontSize: 20)),
                          child: DropdownButton(
                              value: _digits,
                              onChanged: (value) {
                                setState(() {
                                  _digits = value;
                                });
                              },
                              isExpanded: true,
                              items: const <DropdownMenuItem>[
                                DropdownMenuItem(
                                    child: const Text("6"), value: 6),
                                DropdownMenuItem(
                                    child: const Text("8"), value: 8),
                              ]))
                      : Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: _boxDecoration,
                          child: ListBody(children: [
                            Padding(
                                child:
                                    Text(AppLocalizations.of(context).digits),
                                padding: const EdgeInsets.only(bottom: 8)),
                            CupertinoSegmentedControl(
                              groupValue: _digits.toString(),
                              children: {
                                '6': const Text('6'),
                                '8': const Text('8')
                              },
                              onValueChanged: (v) {
                                setState(() {
                                  _digits = int.parse(v);
                                });
                              },
                            )
                          ])),
                  // Time step
                  isPlatformAndroid()
                      ? InputDecorator(
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 10),
                              labelText: AppLocalizations.of(context).period,
                              border: InputBorder.none,
                              labelStyle: const TextStyle(fontSize: 20)),
                          child: DropdownButton(
                              value: _period,
                              onChanged: (value) {
                                setState(() {
                                  _period = value;
                                });
                              },
                              isExpanded: true,
                              items: const <DropdownMenuItem>[
                                DropdownMenuItem(
                                    child: const Text("30"), value: 30),
                                DropdownMenuItem(
                                    child: const Text("60"), value: 60),
                              ]))
                      : Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: _boxDecoration,
                          child: ListBody(children: [
                            Padding(
                                child:
                                    Text(AppLocalizations.of(context).period),
                                padding: const EdgeInsets.only(bottom: 8)),
                            CupertinoSegmentedControl(
                              groupValue: _period.toString(),
                              children: {
                                '30': const Text('30'),
                                '60': const Text('60')
                              },
                              onValueChanged: (v) {
                                setState(() {
                                  _period = int.parse(v);
                                });
                              },
                            )
                          ])),
                  // Add button
                  isPlatformAndroid()
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: RaisedButton(
                            child: Text(AppLocalizations.of(context).add),
                            onPressed: handleAdd,
                          ))
                      : Container()
                ],
              ))),
    );
  }
}
