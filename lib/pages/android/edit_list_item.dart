import 'package:another_authenticator/state/app_state.dart';
import 'package:flutter/material.dart';

/// Item for edit page (Android).
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
      child: Card(
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
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Align to start (left)
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Issuer
                Text(widget.item.totp.getIssuer() ?? "",
                    style: Theme.of(context).textTheme.titleMedium),
                // Generated code
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(widget.item.totp.placeholder,
                        style: Theme.of(context).textTheme.displaySmall)),
                // Account name
                Text(widget.item.totp.getAccountName(),
                    style: Theme.of(context).textTheme.bodyMedium)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
