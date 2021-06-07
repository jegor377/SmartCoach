import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_coach/models/training.dart';
import 'package:smart_coach/screens/repeat_days_selector.dart';
import 'package:smart_coach/screens/training_exercise_setter.dart';

class CreatingTrainingPlanScreen extends StatefulWidget {
  static const routeName = '/new_plan';

  const CreatingTrainingPlanScreen({Key? key}) : super(key: key);

  @override
  _CreatingTrainingPlanScreenState createState() => _CreatingTrainingPlanScreenState();
}

class _CreatingTrainingPlanScreenState extends State<CreatingTrainingPlanScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _trainingPlan = TrainingPlan(
      name: "Normalny plan",
      repeatsOnFriday: true,
      repeatsOnWednesday: true,
      repeatsOnMonday: true,
      exercises: [
        TrainingExercise(
            type: TrainingExerciseType.NORMAL,
            description: "20 przysiadow"
        ),
        TrainingExercise(
            type: TrainingExerciseType.NORMAL,
            description: "10 pompek"
        ),
        TrainingExercise(
            type: TrainingExerciseType.TIMED,
            description: "30s planka",
            time: 30
        ),
      ]
  );

  void _setRepeatDays() async {
    RepeatingDaysScreenArguments? result = await Navigator.pushNamed(
      context,
      RepeatDaysSelectorScreen.routeName,
      arguments: _trainingPlan.repeatingDaysScreenArgs,
    ) as RepeatingDaysScreenArguments?;
    setState(() {
      if(result != null && !identical(result, _trainingPlan.repeatingDaysScreenArgs)) {
        _trainingPlan.repeatingDaysScreenArgs = result;
      }
    });
  }

  void _reorderExercises(int oldIndex, int newIndex) {
    setState(() {
      if(oldIndex < newIndex) {
        newIndex -= 1;
      }
      final TrainingExercise plan = _trainingPlan.exercises.removeAt(oldIndex);
      _trainingPlan.exercises.insert(newIndex, plan);
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _trainingPlan.exercises.removeAt(index);
    });
  }

  Widget _getExerciseListTile(BuildContext context, int index) {
    TrainingExercise exercise = _trainingPlan.exercises[index];
    List<IconData> exerciseTypeIcons = [
      Icons.accessibility,
      Icons.timer,
    ];
    return ListTile(
      onTap: () async {
        TrainingExercise? changedExercise = await Navigator.pushNamed(
          context,
          TrainingExerciseSetterScreen.routeName,
          arguments: _trainingPlan.exercises[index]
        ) as TrainingExercise?;
        if(changedExercise != null) {
          _trainingPlan.exercises[index] = changedExercise;
        }
      },
      leading: Icon(
        exerciseTypeIcons[exercise.type.index],
      ),
      title: Text(_trainingPlan.exercises[index].description),
      subtitle: exercise.type == TrainingExerciseType.TIMED ? Text("Duration time: ${exercise.timeLabel}") : null,
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => _removeExercise(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Training Plan'),
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
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Name",
                      hintText: "Enter training plan's name",
                    ),
                    validator: (String? value) {
                      if(value == null || value.isEmpty) {
                        return 'Please enter some name';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
                    child: const Text('Repeat days'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_trainingPlan.repeatingDays),
                      IconButton(
                        onPressed: _setRepeatDays,
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
                    child: const Text('Exercises'),
                  ),
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _trainingPlan.exercises.length,
                    itemBuilder: (context, index) {
                      return Card(
                        key: ValueKey(index),
                        child: _getExerciseListTile(context, index),
                      );
                    },
                    onReorder: _reorderExercises,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          print("VALID");
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
