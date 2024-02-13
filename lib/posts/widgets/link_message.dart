import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

TextSpan linkMessage(String text, List<InlineSpan>? children) {
  return TextSpan(
    text: text,
    style: const TextStyle(
        color: Colors.blueAccent, decoration: TextDecoration.underline),
    recognizer: TapGestureRecognizer()
      ..onTap = () {
        launchUrl(Uri.parse(text));
      },
    children: children
  );
}
