/// Adaptive TextField
/// Adapted from flutter/flutter, using TextFormField, CupertinoTextField
/// Generated using generate_adaptive.py
///
/// Licensed under:
/// https://raw.githubusercontent.com/flutter/flutter/master/LICENSE

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import './adaptive_base.dart';

const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoColors.lightBackgroundGray,
  style: BorderStyle.solid,
  width: 0.0,
);
const Border _kDefaultRoundedBorder = Border(
  top: _kDefaultRoundedBorderSide,
  bottom: _kDefaultRoundedBorderSide,
  left: _kDefaultRoundedBorderSide,
  right: _kDefaultRoundedBorderSide,
);
const BoxDecoration _kDefaultRoundedBorderDecoration = BoxDecoration(
  border: _kDefaultRoundedBorder,
  borderRadius: BorderRadius.all(Radius.circular(4.0)),
);

class AdaptiveAndroidTextFieldData {
  final Key key;
  final TextEditingController controller;
  final String initialValue;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final TextStyle style;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool autovalidate;
  final bool maxLengthEnforced;
  final int maxLines;
  final int maxLength;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;

  AdaptiveAndroidTextFieldData(
      {this.key,
      this.controller,
      this.initialValue,
      this.focusNode,
      this.decoration,
      this.keyboardType,
      this.textCapitalization,
      this.textInputAction,
      this.style,
      this.textDirection,
      this.textAlign,
      this.autofocus,
      this.obscureText,
      this.autocorrect,
      this.autovalidate,
      this.maxLengthEnforced,
      this.maxLines,
      this.maxLength,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.onSaved,
      this.validator,
      this.inputFormatters,
      this.enabled,
      this.keyboardAppearance,
      this.scrollPadding,
      this.enableInteractiveSelection});
}

class AdaptiveCupertinoTextFieldData {
  final Key key;
  final TextEditingController controller;
  final FocusNode focusNode;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry padding;
  final String placeholder;
  final Widget prefix;
  final OverlayVisibilityMode prefixMode;
  final Widget suffix;
  final OverlayVisibilityMode suffixMode;
  final OverlayVisibilityMode clearButtonMode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle style;
  final TextAlign textAlign;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final int maxLines;
  final int maxLength;
  final bool maxLengthEnforced;
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onSubmitted;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final double cursorWidth;
  final Radius cursorRadius;
  final Color cursorColor;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;

  AdaptiveCupertinoTextFieldData(
      {this.key,
      this.controller,
      this.focusNode,
      this.decoration,
      this.padding,
      this.placeholder,
      this.prefix,
      this.prefixMode,
      this.suffix,
      this.suffixMode,
      this.clearButtonMode,
      this.keyboardType,
      this.textInputAction,
      this.textCapitalization,
      this.style,
      this.textAlign,
      this.autofocus,
      this.obscureText,
      this.autocorrect,
      this.maxLines,
      this.maxLength,
      this.maxLengthEnforced,
      this.onChanged,
      this.onEditingComplete,
      this.onSubmitted,
      this.inputFormatters,
      this.enabled,
      this.cursorWidth,
      this.cursorRadius,
      this.cursorColor,
      this.keyboardAppearance,
      this.scrollPadding});
}

class AdaptiveTextField
    extends AdaptiveBase<TextFormField, CupertinoTextField> {
  final AdaptiveAndroidTextFieldData androidData;
  final AdaptiveCupertinoTextFieldData cupertinoData;
  final Key key;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final TextStyle style;
  final TextAlign textAlign;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool maxLengthEnforced;
  final int maxLines;
  final int maxLength;
  final VoidCallback onEditingComplete;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;

  AdaptiveTextField(
      {this.androidData,
      this.cupertinoData,
      this.key,
      this.controller,
      this.focusNode,
      this.keyboardType,
      this.textCapitalization: TextCapitalization.none,
      this.textInputAction,
      this.style,
      this.textAlign: TextAlign.start,
      this.autofocus: false,
      this.obscureText: false,
      this.autocorrect: true,
      this.maxLengthEnforced: true,
      this.maxLines: 1,
      this.maxLength,
      this.onEditingComplete,
      this.inputFormatters,
      this.enabled: true,
      this.keyboardAppearance,
      this.scrollPadding: const EdgeInsets.all(20.0)});

  TextFormField createAndroidWidget(BuildContext context) {
    return TextFormField(
      key: androidData?.key ?? key,
      controller: androidData?.controller ?? controller,
      initialValue: androidData?.initialValue,
      focusNode: androidData?.focusNode ?? focusNode,
      decoration: androidData?.decoration ?? const InputDecoration(),
      keyboardType: androidData?.keyboardType ?? keyboardType,
      textCapitalization: androidData?.textCapitalization ??
          textCapitalization ??
          TextCapitalization.none,
      textInputAction: androidData?.textInputAction ?? textInputAction,
      style: androidData?.style ?? style,
      textDirection: androidData?.textDirection,
      textAlign: androidData?.textAlign ?? textAlign ?? TextAlign.start,
      autofocus: androidData?.autofocus ?? autofocus ?? false,
      obscureText: androidData?.obscureText ?? obscureText ?? false,
      autocorrect: androidData?.autocorrect ?? autocorrect ?? true,
      autovalidate: androidData?.autovalidate ?? false,
      maxLengthEnforced:
          androidData?.maxLengthEnforced ?? maxLengthEnforced ?? true,
      maxLines: androidData?.maxLines ?? maxLines ?? 1,
      maxLength: androidData?.maxLength ?? maxLength,
      onEditingComplete: androidData?.onEditingComplete ?? onEditingComplete,
      onFieldSubmitted: androidData?.onFieldSubmitted,
      onSaved: androidData?.onSaved,
      validator: androidData?.validator,
      inputFormatters: androidData?.inputFormatters ?? inputFormatters,
      enabled: androidData?.enabled ?? enabled ?? true,
      keyboardAppearance: androidData?.keyboardAppearance ?? keyboardAppearance,
      scrollPadding: androidData?.scrollPadding ??
          scrollPadding ??
          const EdgeInsets.all(20.0),
      enableInteractiveSelection:
          androidData?.enableInteractiveSelection ?? true,
    );
  }

  CupertinoTextField createCupertinoWidget(BuildContext context) {
    return CupertinoTextField(
      key: cupertinoData?.key ?? key,
      controller: cupertinoData?.controller ?? controller,
      focusNode: cupertinoData?.focusNode ?? focusNode,
      decoration: cupertinoData?.decoration ?? _kDefaultRoundedBorderDecoration,
      padding: cupertinoData?.padding ?? const EdgeInsets.all(6.0),
      placeholder: cupertinoData?.placeholder,
      prefix: cupertinoData?.prefix,
      prefixMode: cupertinoData?.prefixMode ?? OverlayVisibilityMode.always,
      suffix: cupertinoData?.suffix,
      suffixMode: cupertinoData?.suffixMode ?? OverlayVisibilityMode.always,
      clearButtonMode:
          cupertinoData?.clearButtonMode ?? OverlayVisibilityMode.never,
      keyboardType: cupertinoData?.keyboardType ?? keyboardType,
      textInputAction: cupertinoData?.textInputAction ?? textInputAction,
      textCapitalization: cupertinoData?.textCapitalization ??
          textCapitalization ??
          TextCapitalization.none,
      style: cupertinoData?.style ?? style,
      textAlign: cupertinoData?.textAlign ?? textAlign ?? TextAlign.start,
      autofocus: cupertinoData?.autofocus ?? autofocus ?? false,
      obscureText: cupertinoData?.obscureText ?? obscureText ?? false,
      autocorrect: cupertinoData?.autocorrect ?? autocorrect ?? true,
      maxLines: cupertinoData?.maxLines ?? maxLines ?? 1,
      maxLength: cupertinoData?.maxLength ?? maxLength,
      maxLengthEnforced:
          cupertinoData?.maxLengthEnforced ?? maxLengthEnforced ?? true,
      onChanged: cupertinoData?.onChanged,
      onEditingComplete: cupertinoData?.onEditingComplete ?? onEditingComplete,
      onSubmitted: cupertinoData?.onSubmitted,
      inputFormatters: cupertinoData?.inputFormatters ?? inputFormatters,
      enabled: cupertinoData?.enabled ?? enabled,
      cursorWidth: cupertinoData?.cursorWidth ?? 2.0,
      cursorRadius: cupertinoData?.cursorRadius,
      cursorColor: cupertinoData?.cursorColor ?? CupertinoColors.activeBlue,
      keyboardAppearance:
          cupertinoData?.keyboardAppearance ?? keyboardAppearance,
      scrollPadding: cupertinoData?.scrollPadding ??
          scrollPadding ??
          const EdgeInsets.all(20.0),
    );
  }
}
