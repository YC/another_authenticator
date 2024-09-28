import 'package:another_authenticator/state/app_state.dart';
import 'package:another_authenticator/ui/adaptive.dart'
    show AdaptiveDialogAction, AppScaffold, isPlatformAndroid;
import 'package:another_authenticator_otp/models/otp_algorithm.dart';
import 'package:another_authenticator_otp/otp.dart' show Base32, OtpItem;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Page for adding accounts.
class AddPage extends StatefulWidget {
  AddPage({Key? key}) : super(key: key);

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
  void addItem(OtpItem item) {
    try {
      Provider.of<AppState>(context, listen: false).addItem(item).then((_) {
        Navigator.pop(context);
      });
    } catch (e) {
      // TODO: Fix exception handling
      var errMessage = e.toString();
      if (e.toString().contains('DUPLICATE_ACCOUNT')) {
        errMessage = AppLocalizations.of(context)!.errDuplicateAccount;
      } else if (e.toString().contains('ID_COLLISION')) {
        errMessage = AppLocalizations.of(context)!.errIdCollision;
      }

      showAdaptiveDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog.adaptive(
                title: Text(AppLocalizations.of(context)!.error),
                content: Text(errMessage),
                actions: [
                  AdaptiveDialogAction(
                      child: Text(AppLocalizations.of(context)!.ok),
                      onPressed: Navigator.of(context).pop)
                ]);
          });
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // No iOS validator, so may need to recheck and fail
    if (!secretFieldValid()) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(AppLocalizations.of(context)!.error),
            content: Text(AppLocalizations.of(context)!.secretInvalidMessage),
            actions: [
              CupertinoDialogAction(
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: Navigator.of(context).pop)
            ],
          );
        },
      );
      return;
    }

    // Initialise and add TOTP item
    var item = OtpItem(
        _secretController.text,
        _digits,
        _period,
        OtpHashAlgorithm.sha1,
        _issuerController.text,
        _accountNameController.text);

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
      title: Text(AppLocalizations.of(context)!.addTitle),
      cupertinoNavigationBar: CupertinoNavigationBar(
          middle: Text(AppLocalizations.of(context)!.addTitle),
          trailing: CupertinoButton(
              padding: const EdgeInsets.all(0),
              child: Text(AppLocalizations.of(context)!.add),
              onPressed: handleAdd)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: ListView(
            children: isPlatformAndroid()
                ? <Widget>[
                    // Key
                    TextFormField(
                      controller: _secretController,
                      textCapitalization: TextCapitalization.characters,
                      autocorrect: false,
                      autovalidateMode: _secretAutoValidation
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      validator: (value) => secretFieldValid()
                          ? null
                          : AppLocalizations.of(context)!.secretInvalidMessage,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.secret),
                    ),
                    // Provider
                    TextFormField(
                      controller: _issuerController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.issuer,
                          hintText: 'Example Service'),
                    ),

                    // Account name
                    TextFormField(
                      controller: _accountNameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.accountName,
                          hintText: 'user@example.com'),
                    ),

                    // # of digits
                    InputDecorator(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 15),
                        labelText: AppLocalizations.of(context)!.digits,
                        border: InputBorder.none,
                        labelStyle: const TextStyle(fontSize: 20),
                      ),
                      child: DropdownButton(
                        value: _digits,
                        onChanged: (value) {
                          setState(() {
                            _digits = value;
                          });
                        },
                        isExpanded: true,
                        items: const <DropdownMenuItem>[
                          DropdownMenuItem(child: const Text("6"), value: 6),
                          DropdownMenuItem(child: const Text("8"), value: 8),
                        ],
                      ),
                    ),

                    // Time step
                    InputDecorator(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(top: 10),
                          labelText: AppLocalizations.of(context)!.period,
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
                          DropdownMenuItem(child: const Text("30"), value: 30),
                          DropdownMenuItem(child: const Text("60"), value: 60),
                        ],
                      ),
                    ),

                    // Add button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ElevatedButton(
                        child: Text(AppLocalizations.of(context)!.add),
                        onPressed: handleAdd,
                      ),
                    )
                  ]
                : <Widget>[
                    // Key
                    CupertinoTextField(
                        controller: _secretController,
                        textCapitalization: TextCapitalization.characters,
                        autocorrect: false,
                        decoration: _boxDecoration,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        prefix: Text(AppLocalizations.of(context)!.secret),
                        textAlign: TextAlign.right),

                    // Provider
                    CupertinoTextField(
                        controller: _issuerController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _boxDecoration,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        prefix: Text(AppLocalizations.of(context)!.issuer),
                        textAlign: TextAlign.right),

                    // Account name
                    CupertinoTextField(
                        controller: _accountNameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _boxDecoration,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        prefix: Text(AppLocalizations.of(context)!.accountName),
                        textAlign: TextAlign.right),

                    // # of digits
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: _boxDecoration,
                      child: ListBody(
                        children: [
                          Padding(
                              child: Text(AppLocalizations.of(context)!.digits),
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
                        ],
                      ),
                    ),

                    // Time step
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: _boxDecoration,
                      child: ListBody(
                        children: [
                          Padding(
                              child: Text(AppLocalizations.of(context)!.period),
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
                        ],
                      ),
                    ),

                    // Add button
                    Container()
                  ],
          ),
        ),
      ),
    );
  }
}
