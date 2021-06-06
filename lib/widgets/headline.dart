import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  Headline({required this.text_content});

  final String text_content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 15.0, 0, 20.0),
      child: Text(
        text_content,
        style: HeadlineStyle(),
      ),
    );
  }

}

class HeadlineStyle extends TextStyle {
  HeadlineStyle({Color color = Colors.white}) : super(
    color: color,
    fontSize: 20.0,
  );
}