import 'package:flutter/material.dart';
import 'package:flutter_bloc/utils/localizations.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  final AsyncSnapshot<String> snapshot;
  final Function(String) onChanged;
  final TextInputType textInputType;
  final String labelText;
  final bool enabled;
  final bool obscureText;
  final OutlineInputBorder outlineBorder;
  final OutlineInputBorder focusOutlineBorder;
  final Color textColor;
  final Icon icon;

  final defaultOutlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  );

  InputTextField(
      {this.controller,
      this.snapshot,
      this.onChanged,
      this.textInputType = TextInputType.text,
      this.labelText,
      this.outlineBorder,
      this.focusOutlineBorder,
      this.textColor,
      this.icon,
      this.enabled = true,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: textInputType,
      autocorrect: false,
      enabled: enabled,
      obscureText: obscureText,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: labelText,
        icon: icon,
        errorText: AppLocalizations.of(context).keyString(snapshot.error),
        labelStyle: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        ),
        enabledBorder: outlineBorder ?? defaultOutlineInputBorder,
        disabledBorder: outlineBorder ?? defaultOutlineInputBorder,
        focusedBorder: focusOutlineBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
        border: outlineBorder ?? defaultOutlineInputBorder,
      ),
      style: TextStyle(
        color: textColor ?? Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
