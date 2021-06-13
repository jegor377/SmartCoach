import 'package:flutter/material.dart';
import 'package:smart_coach/models/repeating_days.dart';

class RepeatDaysSelectorScreen extends StatefulWidget {
  static const String routeName = '/repeat_days_selector';

  const RepeatDaysSelectorScreen({Key? key}) : super(key: key);

  @override
  _RepeatDaysSelectorScreenState createState() => _RepeatDaysSelectorScreenState();
}

class _RepeatDaysSelectorScreenState extends State<RepeatDaysSelectorScreen> {
  TrainingRepeatingDays _repeatingDays = TrainingRepeatingDays();

  @override
  Widget build(BuildContext context) {
    TrainingRepeatingDays? newRepeatingDays = ModalRoute.of(context)!.settings.arguments as TrainingRepeatingDays?;
    _repeatingDays = newRepeatingDays != null ? newRepeatingDays : _repeatingDays;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Repeat Days'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                child: Text('You will get notified to do the workout in specified days.'),
            ),
            CheckboxListTile(
                title: const Text('Monday'),
                value: _repeatingDays.repeatsOnMonday,
                onChanged: (bool? val) {
                  setState(() {
                    _repeatingDays.repeatsOnMonday = val != null ? val : false;
                  });
                }
            ),
            CheckboxListTile(
                title: const Text('Tuesday'),
                value: _repeatingDays.repeatsOnTuesday,
                onChanged: (bool? val) {
                  setState(() {
                    _repeatingDays.repeatsOnTuesday = val != null ? val : false;
                  });
                }
            ),
            CheckboxListTile(
                title: const Text('Wednesday'),
                value: _repeatingDays.repeatsOnWednesday,
                onChanged: (bool? val) {
                  setState(() {
                    _repeatingDays.repeatsOnWednesday = val != null ? val : false;
                  });
                }
            ),
            CheckboxListTile(
                title: const Text('Thursday'),
                value: _repeatingDays.repeatsOnThursday,
                onChanged: (bool? val) {
                  setState(() {
                    _repeatingDays.repeatsOnThursday = val != null ? val : false;
                  });
                }
            ),
            CheckboxListTile(
                title: const Text('Friday'),
                value: _repeatingDays.repeatsOnFriday,
                onChanged: (bool? val) {
                  setState(() {
                    _repeatingDays.repeatsOnFriday = val != null ? val : false;
                  });
                }
            ),
            CheckboxListTile(
                title: const Text('Saturday'),
                value: _repeatingDays.repeatsOnSaturday,
                onChanged: (bool? val) {
                  setState(() {
                    _repeatingDays.repeatsOnSaturday = val != null ? val : false;
                  });
                }
            ),
            CheckboxListTile(
                title: const Text('Sunday'),
                value: _repeatingDays.repeatsOnSunday,
                onChanged: (bool? val) {
                  setState(() {
                    _repeatingDays.repeatsOnSunday = val != null ? val : false;
                  });
                }
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    _repeatingDays
                  );
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      )
    );
  }
}
