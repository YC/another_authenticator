import 'package:another_authenticator/state/app_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Material, CheckboxListTile, Icons;
import 'package:flutter/cupertino.dart' show CupertinoColors;

/// Item for edit page (Cupertino).
class EditListItem extends StatefulWidget {
  EditListItem(this.item, this.addRemovalItem, this.removeRemovalItem,
      {Key? key})
      : super(key: key);

  final BaseItemType item;

  // Adds/removes the item from the removal list
  final Function addRemovalItem;
  final Function removeRemovalItem;

  @override
  State<StatefulWidget> createState() {
    return _EditListItem();
  }
}

class _EditListItem extends State<EditListItem> {
  // Whether item is currently selected
  bool? _value = false;

  @override
  Widget build(BuildContext context) {
    return Hero(
      key: widget.key,
      tag: widget.item.id,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Material(
          color: CupertinoColors.white,
          child: CheckboxListTile(
            secondary: const Icon(Icons.drag_handle),
            onChanged: (e) {
              // Add/remove items
              if (e == true) {
                widget.addRemovalItem(widget.item.id);
              } else {
                widget.removeRemovalItem(widget.item.id);
              }

              // Set checkbox state
              setState(() {
                _value = e;
              });
            },
            value: _value,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // Align to start (left)
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Issuer
                  Text(widget.item.totp.getIssuer() ?? ""),
                  // Generated code
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(widget.item.totp.placeholder,
                          style: const TextStyle(
                              fontSize: 40,
                              color: Color.fromARGB(255, 125, 125, 125)))),
                  // Account name
                  Text(widget.item.totp.getAccountName(),
                      style: const TextStyle(fontSize: 13))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
