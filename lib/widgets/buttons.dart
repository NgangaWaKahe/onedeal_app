import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonsGenerator {
  static Widget createButton(
      BuildContext context, Function() onTap, String buttonlabel,
      {Color forecolor = Colors.white, Color backgroundColor = Colors.red}) {
    return ElevatedButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(forecolor),
            backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: backgroundColor)))),
        onPressed: onTap,
        child: Text(buttonlabel.toUpperCase(),
            style: const TextStyle(fontSize: 14)));
  }
}
