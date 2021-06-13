import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_coach/models/repeating_days.dart';
import 'package:smart_coach/screens/repeat_days_selector.dart';
import 'package:smart_coach/singletons/settings.dart';
import 'package:smart_coach/singletons/native_api.dart';

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
            SwitchListTile(
              title: const Text('Training notifications'),
              value: Settings.shouldNotify,
              contentPadding: EdgeInsets.all(0),
              onChanged: (bool value) async {
                setState(() {
                  Settings.shouldNotify = value;
                });
                await Settings.save();
                await Settings.resetNotificationService();
              }
            ),
            buildTitle('Training notification time'),
            buildEditableInformation(
              'Shows at ${Settings.notificationTime}',
              () async {
                TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: Settings.notificationTime.toTimeOfDay(),
                );
                if(time != null) {
                  setState(() {
                    Settings.notificationTime = NotifyTime.fromTimeOfDay(time);
                  });
                  await Settings.save();
                  await Settings.resetNotificationService();
                }
              }
            ),
            buildTitle('Training notify days'),
            buildEditableInformation(
              Settings.repeatingDays.toString(), () async {
                TrainingRepeatingDays? repeatingDays = await Navigator.of(context).pushNamed(
                  RepeatDaysSelectorScreen.routeName,
                  arguments: Settings.repeatingDays,
                ) as TrainingRepeatingDays?;
                if(repeatingDays != null) {
                  setState(() {
                    Settings.repeatingDays = repeatingDays;
                  });
                  await Settings.save();
                  await Settings.resetNotificationService();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
