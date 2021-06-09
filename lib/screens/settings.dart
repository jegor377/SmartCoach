import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_coach/singletons/settings.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Widget buildTitle(String text, {bool isFirst = false}) => Padding(
    padding: EdgeInsets.fromLTRB(0, 15.0, 0, 5.0),
    child: Text(
        text,
    ),
  );

  Widget buildInformation(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 20.0,
    ),
  );

  Widget buildEditableInformation(String text, void Function()? handler) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      buildInformation(text),
      IconButton(onPressed: handler, icon: Icon(Icons.edit)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle('Training notification time'),
            buildEditableInformation(
              'Everyday at ${Settings.notificationTimeLabel}',
              () async {
                TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: Settings.notificationTime,
                );
                if(time != null) {
                  setState(() {
                    Settings.notificationTime = time;
                    Settings.save();
                  });
                }
              }
            ),
          ],
        ),
      ),
    );
  }
}
