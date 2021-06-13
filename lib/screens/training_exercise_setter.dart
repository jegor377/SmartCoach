import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:smart_coach/models/exercise.dart';

class TrainingExerciseSetterScreen extends StatefulWidget {
  static const String routeName = "/training_exercise_setter";

  const TrainingExerciseSetterScreen({Key? key}) : super(key: key);

  @override
  _TrainingExerciseSetterScreenState createState() => _TrainingExerciseSetterScreenState();
}

class _TrainingExerciseSetterScreenState extends State<TrainingExerciseSetterScreen> {
  final _formKey = GlobalKey<FormState>();
  TrainingExercise _exercise = TrainingExercise.empty();
  Map<TrainingExerciseType, String> _exerciseTypeNames = {
    TrainingExerciseType.normal: 'Normal',
    TrainingExerciseType.timed: 'Timed',
  };

  List<DropdownMenuItem<TrainingExerciseType>> _dropdownItems() {
    List<DropdownMenuItem<TrainingExerciseType>> result = [];

    _exerciseTypeNames.forEach((key, value) {
      result.add(
          DropdownMenuItem(
              value: key,
              child: Text(_exerciseTypeNames[key]!)
          )
      );
    });
    return result;
  }

  Widget _durationTimeTimer() {
    return Row(
      children: [
        Column(
          children: [
            Text('Hours'),
            NumberPicker(
              value: _exercise.hours,
              minValue: 0,
              maxValue: 24,
              onChanged: (value) {
                setState(() {
                  _exercise.hours = value;
                });
              },
            ),
          ],
        ),
        Column(
          children: [
            Text('Minutes'),
            NumberPicker(
              value: _exercise.minutes,
              minValue: 0,
              maxValue: 60,
              onChanged: (value) {
                setState(() {
                  _exercise.minutes = value;
                });
              },
            ),
          ],
        ),
        Column(
          children: [
            Text('Seconds'),
            NumberPicker(
              value: _exercise.seconds,
              minValue: 0,
              maxValue: 60,
              onChanged: (value) {
                setState(() {
                  _exercise.seconds = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TrainingExercise? newTrainingExercise = ModalRoute.of(context)!.settings.arguments as TrainingExercise?;
    _exercise = newTrainingExercise != null ? newTrainingExercise : _exercise;

    return Scaffold(
      appBar: AppBar(
        title: Text('Set Exercise'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                    child: Text('Exercise type'),
                  ),
                  DropdownButton<TrainingExerciseType>(
                      value: _exercise.type,
                      onChanged: (TrainingExerciseType? _type) {
                        setState(() {
                          if(_type != null) {
                            _exercise.type = _type;
                          }
                        });
                      },
                      items: _dropdownItems()
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Exercise description',
                      hintText: 'Enter exercise description',
                    ),
                    initialValue: _exercise.description,
                    onChanged: (value) => _exercise.description = value,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Please enter some description';
                      }
                    },
                  ),
                  if(_exercise.type == TrainingExerciseType.timed)
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20.0, 0, 15.0),
                      child: const Text('Choose duration time'),
                    ),
                  if(_exercise.type == TrainingExerciseType.timed)
                    _durationTimeTimer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          if(_exercise.type == TrainingExerciseType.timed && _exercise.time == 0) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Wrong exercise time!'),
                                  content: const Text('Please specify non zero exercise time'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK')
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop(_exercise);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}
