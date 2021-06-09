import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactScreen extends StatelessWidget {
  static const String routeName = '/contact';

  const ContactScreen({Key? key}) : super(key: key);

  Widget buildTitle(String text, {bool isFirst = false}) => Padding(
    padding: EdgeInsets.fromLTRB(0, 15.0, 0, 5.0),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.orange,
      )
    ),
  );

  Widget buildInformation(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 20.0,
    ),
  );

  Widget buildClickableInformation(String text, BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        text,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      IconButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: text));
          final snackBar = SnackBar(
            content: Text('Copied to clipboard! :D'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        icon: const Icon(Icons.copy),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey.shade900, spreadRadius: 5)],
                ),
                child: Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.png'),
                    radius: 60.0,
                  ),
                ),
              )
            ),
            buildTitle('Author', isFirst: true),
            buildInformation('Igor Santarek'),
            buildTitle('E-mail'),
            buildClickableInformation('jegor377@gmail.com', context),
            buildTitle('GitHub'),
            buildClickableInformation('https://github.com/jegor377', context),
          ],
        ),
      ),
    );
  }
}
