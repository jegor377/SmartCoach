import 'package:flutter/material.dart';
import 'package:smart_coach/models/training.dart';

class TrainingExerciseSetterScreen extends StatefulWidget {
  static const String routeName = "/training_exercise_setter";

  const TrainingExerciseSetterScreen({Key? key}) : super(key: key);

  @override
  _TrainingExerciseSetterScreenState createState() => _TrainingExerciseSetterScreenState();
}

class _TrainingExerciseSetterScreenState extends State<TrainingExerciseSetterScreen> {
  TrainingExerciseType _exerciseType = TrainingExerciseType.NORMAL;
  List<String> _exerciseTypeNames = [
    'Normal',
    'Timed'
  ];

  List<DropdownMenuItem<TrainingExerciseType>> _dropdownItems() {
    List<DropdownMenuItem<TrainingExerciseType>> result = [];

    for(int i = 0; i < _exerciseTypeNames.length; i++) {
      result.add(
        DropdownMenuItem(
          value: TrainingExerciseType.values[i],
          child: Text(_exerciseTypeNames[i])
        )
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Exercise'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                child: Text('Exercise type'),
              ),
              DropdownButton<TrainingExerciseType>(
                value: _exerciseType,
                onChanged: (TrainingExerciseType? type) {
                  setState(() {
                    if(type != null) {
                      _exerciseType = type;
                    }
                  });
                },
                items: _dropdownItems()
              )
            ],
          ),
        ),
      )
    );
  }
}
