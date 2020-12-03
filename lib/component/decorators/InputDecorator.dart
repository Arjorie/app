import 'package:flutter/material.dart';

InputDecoration getInputDecoration(
    {BuildContext context, String label, Widget suffixIcon}) {
  return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      labelText: label,
      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          borderSide:
              BorderSide(width: 1, color: Theme.of(context).accentColor)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          borderSide:
              BorderSide(width: 1, color: Theme.of(context).accentColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          borderSide:
              BorderSide(width: 2, color: Theme.of(context).primaryColor)),
      suffixIcon: suffixIcon != null ? suffixIcon : null);
}
