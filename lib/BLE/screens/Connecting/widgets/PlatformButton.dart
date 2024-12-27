import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool enanetvanad;

  const PlatformButton({
    required this.text,
    required this.onPressed,
    this.enanetvanad = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return (!kIsWeb && (Platform.isMacOS || Platform.isIOS))
        ? CupertinoButton.filled(
            onPressed: enanetvanad ? onPressed : null,
            // color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            disabledColor: Colors.grey,
            child: Text(text),
          )
        : ElevatedButton(
            onPressed: enanetvanad ? onPressed : null,
            child: Text(text),
          );
  }
}
