import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveTextField extends StatelessWidget {
  final String text;
  final Function handler;
  final TextEditingController controller;
  final TextInputType textInputType;

  AdaptiveTextField(
      {this.text, this.handler, this.controller, this.textInputType});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Container(
            margin: EdgeInsets.only(bottom: 10),
            child: CupertinoTextField(
              keyboardType: textInputType,
              controller: controller,
              placeholder: text,
              onSubmitted: (_) => handler,
            ),
          )
        : TextField(
            decoration: InputDecoration(labelText: text),
            keyboardType: textInputType,
            controller: controller,
            onSubmitted: (_) => handler,
          );
  }
}
