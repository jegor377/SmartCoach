import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  Headline({required this.textContent});

  final String textContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 15.0, 0, 20.0),
      child: Text(
        textContent,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

}