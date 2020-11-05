import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveRaisedButton extends StatelessWidget {
  final String text;
  final Function handler;

  AdaptiveRaisedButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton.filled(
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: handler,
          )
        : RaisedButton(
            onPressed: handler,
            child: Text(text),
            textColor: Theme.of(context).textTheme.button.color,
            color: Theme.of(context).primaryColor,
          );
  }
}
